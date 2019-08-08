defmodule Luno.Router do
  @moduledoc """
    Top-level URi router.  Forwards versioned URL's onto relevant Routers.
  """
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  ##
  # This is going to change at some point.  Not sure what to do with Non-API URLs yet.
  get "/" do
    body = "Nothing here.."
    send_resp(conn, 200, body)
  end


  forward "/v1", to: Luno.API.V1.Router

  match _ do
    send_resp(conn, 404, "oops")
  end

end
