class DiscordConnection
  attr_accessor :raw, :connection_id

  def initialize(opts)
    @raw = Discordrb::Bot.new(
      token:       opts.token,
      type:        (opts.client_type || :bot),
      parse_self:  !opts.ignore_self,
      ignore_bots: opts.ignore_bots
    )

    @raw.ready do
      @raw.game = "Discord Bot - Ur info here.."
    end
  end

  def connect(*_opts)
    @raw.run true
  end

  def disconnect
    @raw.stop
  end

  def message
    raise 'Discord not connected!' unless @raw

    @raw.message do |event|
      yield event
    end
  end

  def mention
    raise 'Discord not connected!' unless @raw

    @raw.mention do |event|
      yield event
    end
  end
end
