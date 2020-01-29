var API_TOKEN = PropertiesService.getScriptProperties().getProperty('slack_api_token');
if (!API_TOKEN) {
    throw 'You should set "slack_api_token" property from [File] > [Project properties] > [Script properties]';
}
Logger.log("API_" + API_TOKEN);
var FOLDER_NAME = 'Slack Logs';
var COL_LOG_RAW_JSON = 1;
var COL_MAX = COL_LOG_RAW_JSON;
// Slack offers 10,000 history logs for free plan teams
var MAX_HISTORY_PAGINATION = 10;
var HISTORY_COUNT_PER_PAGE = 1000;

function StoreLogsDelta() {
  try {
    Logger.log("started");
    var logger = new SlackChannelHistoryLogger(API_TOKEN);
    logger.run();
    Logger.log("finished");
  } catch (e) {
    Logger.log("error:" + e);
  }
};

function SlackClient(api_token) {
    // wrapper of slack
    this.api_token = api_token;
    Logger.log("api token: " + this.api_token);
}

SlackClient.prototype.request = function(path, params) {
    if (params === void 0) { params = {}; }
    var url = "https://slack.com/api/" + path + "?";
    var qparams = [("token=" + encodeURIComponent(this.api_token))];
    for (var k in params) {
        qparams.push(encodeURIComponent(k) + "=" + encodeURIComponent(params[k]));
    }
    url += qparams.join('&');
    Logger.log("==> GET " + url);
    var resp = UrlFetchApp.fetch(url);
    var data = JSON.parse(resp.getContentText());
    if (data.error) {
        throw "GET " + path + ": " + data.error;
    }
    return data;
}
SlackClient.prototype.getUserList = function() {
    var users = {};
    var usersResp = this.request('users.list');
    usersResp.members.forEach(function (member) {
        users[member.id] = member.name;
    });
    return users;
};
SlackClient.prototype.getTeamName = function() {
    var teamInfoResp = this.request('team.info');
    return teamInfoResp.team.name;
};
SlackClient.prototype.getChannelList = function() {
    var channelsResp = this.request('channels.list');
    return channelsResp.channels;
}
SlackClient.prototype.loadMessagesBulk = function (ch, since) {
    var _this = this;
    var messages = [];
    // channels.history will return the history from the latest to the oldest.
    // If the result's "has_more" is true, the channel has more older history.
    // In this case, use the result's "latest" value to the channel.history API parameters
    // to obtain the older page, and so on.
    var loadSince = function (since) {
        var options = {
            oldest: +since,
            count: HISTORY_COUNT_PER_PAGE,
            channel: ch.id
        }
        // order: recent-to-older
        var resp = _this.request('channels.history', options);
        messages = resp.messages.concat(messages);
        return resp;
    };
    var resp = loadSince(since);
    var page = 1;
    while (resp.has_more && page <= MAX_HISTORY_PAGINATION) {
        resp = loadSince(resp.messages[0].ts);
        page++;
    }
    // oldest-to-recent
    return messages.reverse();
};


var SlackChannelHistoryLogger = (function (api_token) {
    function SlackChannelHistoryLogger() {
        this.memberNames = {};
        this.slack = new SlackClient(api_token)
    }

    SlackChannelHistoryLogger.prototype.run = function () {
        var _this = this;
        this.memberNames = this.slack.getUserList()
        Object.keys(this.memberNames).forEach(function (user) {
            Logger.log("id:" + user + " to be " + _this.memberNames[user]);
        })
        this.teamName = this.slack.getTeamName();
        var channels = this.slack.getChannelList();
        var _this = this;
        channels.forEach(function (ch) {
            Logger.log("Logging channel:" + ch.name);
            _this.importChannelHistoryDelta(ch);
        })
    };
    SlackChannelHistoryLogger.prototype.getLogsFolder = function (path) {
        var folder = DriveApp.getRootFolder();
        path.forEach(function (name) {
            var it = folder.getFoldersByName(name);
            if (it.hasNext()) {
                folder = it.next();
            }
            else {
                folder = folder.createFolder(name);
            }
        });
        return folder;
    };
    SlackChannelHistoryLogger.prototype.getSheet = function (ch, d, cont) {
        var dateString;
        if (d instanceof Date) {
            dateString = this.formatDate(d);
        }
        else {
            dateString = '' + d;
        }
        var spreadsheet;
        var sheetByID = {};
        var folder = this.getLogsFolder([FOLDER_NAME, this.teamName]);
        var spreadsheetName = dateString + "_" + ch.name + "_" + parseInt(cont);
        var it = folder.getFilesByName(spreadsheetName);
        if (it.hasNext()) {
            var file = it.next();
            spreadsheet = SpreadsheetApp.openById(file.getId());
        }
        else {
            spreadsheet = SpreadsheetApp.create(spreadsheetName);
            folder.addFile(DriveApp.getFileById(spreadsheet.getId()));
        }
        var sheets = spreadsheet.getSheets();
        var first = sheets[0];
        if (!first) {
            first = spreadsheet.insertSheet();
        }
        first.setName(dateString + "_" + ch.name)
        return first;
    };
    SlackChannelHistoryLogger.prototype.getChannelHistoryDelta = function (ch) {
        try {
            var _this = this;
            Logger.log("getChannelHistoryDelta " + ch.name + " (" + ch.id + ")");
            var now = new Date();
            var existingSheet = this.getSheet(ch, now, 0);
            if (!existingSheet) {
                // try previous month
                now.setMonth(now.getMonth() - 1);
                existingSheet = this.getSheet(ch, now, 0);
            }
            var oldest = this.getLastTimeStamp(existingSheet);
            if (!oldest) { oldest = "1"; }

            return this.slack.loadMessagesBulk(ch, oldest);
        } catch (e) {
            Logger.log("get channel history delta:" + e);
            return [];
        }
    }
    SlackChannelHistoryLogger.prototype.getLastTimeStamp = function (sheet) {
        try {
            var lastRow = sheet.getLastRow();
            var data = JSON.parse(sheet.getRange(lastRow, COL_LOG_RAW_JSON).getValue());
            return +data.ts || 0;
        }
        catch (_) {
            return 0;
        }
    }

    SlackChannelHistoryLogger.prototype.importChannelHistoryDelta = function (ch) {
        try {
            var _this = this;
            var messages = this.getChannelHistoryDelta(ch);
            var dateStringToMessages = {};
            Logger.log("got " + messages.length + " logs");
            messages.forEach(function (msg) {
                var date = new Date(+msg.ts * 1000);
                var dateString = _this.formatDate(date);
                if (!dateStringToMessages[dateString]) {
                    dateStringToMessages[dateString] = [];
                }
                msg["name"] = _this.memberNames[msg["user"]];
                dateStringToMessages[dateString].push(msg);
                /*
                  dateStringToMessage seems to be
                  {
                  "2016-01": [{message,,}, {message,,},,,],
                  "2016-02": [{message,,}, {message,,},,,]
                  }
                */
            });
            for (var dateString in dateStringToMessages) {
                var sheet = this.getSheet(ch, dateString, 0);
                var lastTS = this.getLastTimeStamp(sheet);
                var rows = dateStringToMessages[dateString].filter(function (msg) {
                    return +msg.ts > lastTS;
                }).map(function (msg) {
                    return [JSON.stringify(msg)];
                });
                var lastRow = sheet.getLastRow();
                if (rows.length > 0) {
                    var range = sheet.insertRowsAfter(lastRow || 1, rows.length)
                        .getRange(lastRow + 1, 1, rows.length, COL_MAX);
                    range.setValues(rows)
                };
                Logger.log("wrote " + parseInt(rows.length) + " rows");
            }
            Logger.log("finished logging:" + ch.name);
        } catch (e) {
            Logger.log("exception on writing sheet: " + e);
        }
    };
    SlackChannelHistoryLogger.prototype.formatDate = function (dt) {
        return Utilities.formatDate(dt, Session.getScriptTimeZone(), 'yyyy-MM');
    };
    return SlackChannelHistoryLogger;
})(API_TOKEN);
