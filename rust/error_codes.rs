#[catch(404)]
fn not_found(req: &Request) -> String {
    format!("Sorry, '{}' is not a valid path.", req.uri())
}

#[catch(403)]
fn forbidden() -> String {
    String::from("Need https")
}

#[catch(401)]
fn unauthorized<'a>() -> Result<Response<'a>,Status> {
    return Response::build()
        .raw_header("WWW-Authenticate","Basic")
        .status(Status::Unauthorized)
        .sized_body(Cursor::new("unauthorized: wrong user and pass"))
        .ok();
}

#[catch(500)]
fn internal_error() -> String{
    String::from("Internal Error")
}
