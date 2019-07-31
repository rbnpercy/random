pub fn connect() -> Database {
    let mongo_uri = get_env_var_or_default("MONGODB_URI","mongodb://localhost:27017");
    let client:Client = Client::with_uri(mongo_uri.as_str()).expect("Failed to initialize mongo client.");
    let db_name = get_env_var_or_default("MONGODB_DATABASE","wiki_mongo");
    let database: Database = client.db(db_name.as_str());

    match [env::var("MONGODB_USER"), env::var("MONGODB_PASS")]{
        [Ok(user),Ok(pass)] => {
            database.auth(user.as_str(),pass.as_str()).expect("Error doing mongo auth");

        },
        [_,_] => {}
    }

    return database;
}
