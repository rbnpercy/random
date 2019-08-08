defmodule Luno.API.V1.Router do
  @moduledoc """
    API Version 1 router.  Matches routes and dispatches to the corresponding handler.
  """
  use Plug.Router
  import Plug.Conn
  import Luno.Plugs.Renderer
  alias Luno.Handlers.V1.Profiles
  alias Luno.Handlers.V1.Events
  # alias Luno.Plug.NotFound
  # alias Luno.Plug.RequestTimeout
  # alias Luno.Plug.RequestTooLarge 

  plug :match
  plug :dispatch
  plug Luno.Plugs.HotCodeReload


  get "/" do
    send_resp(conn, 200, "LOL")
  end

  #####
  #  TOP-LEVEL USER / PROFILE ROUTES.
  #####

  get "/:acc_id/users" do  # GET /users - users#index
    qp = fetch_query_params(conn)
    list = Profiles.get_user_list(acc_id, qp)
    send_okay(conn, list)
  end

  post "/:acc_id/users/" do  # POST /users - users#create
    user = Profiles.create_user(acc_id)
    send_create_resp(conn, user)
  end

  get "/:acc_id/users/:user_id" do  # GET /users/:id - users#show
    if user = Profiles.get_user(acc_id, user_id) do
      send_okay(conn, user)
    else
      send_not_found(conn, %{"status" => 404, "message" => "User not found."})
    end
  end

  get "/:acc_id/users/:user_id/profile" do  # GET /users/:id/profile - users#show
    if profile = Profiles.get_profile(acc_id, user_id) do
      send_okay(conn, profile)
    else
      send_not_found(conn, %{"status" => 404, "message" => "User not found."})
    end
  end

  patch "/:acc_id/users/:user_id" do  # PATCH /users/:id - users#update
    if profile = Profiles.update_user(acc_id, user_id) do
      send_updated(conn, profile)
    else
      send_not_found(conn, %{"status" => 404, "message" => "User not found."})
    end
  end

  put "/:acc_id/users/:user_id" do  # PUT /users/:id - users#update
    if profile = Profiles.update_user(acc_id, user_id) do
      send_updated(conn, profile)
    else
      send_not_found(conn, %{"status" => 404, "message" => "User not found."})
    end
  end

  delete "/:acc_id/users/:user_id" do  # DELETE /users/:id - users#destroy
    if profile = Profiles.delete_user(acc_id, user_id) do
      send_deleted(conn, profile)
    else
      send_not_found(conn, %{"status" => 404, "message" => "User not found."})
    end
  end


  #####
  #  USER EVENT ROUTES.
  #####

  get "/:acc_id/users/:user_id/events" do  # GET /users/:id/events - events#index
    events = Events.get_user_events(acc_id, user_id)
    send_okay(conn, events)
  end

  post "/:acc_id/users/:user_id/events" do  # POST /users/:id/events - events#create
    event = Events.create_event(acc_id, user_id)
    send_create_resp(conn, event)
  end

  get "/:acc_id/users/:user_id/events/:event_id" do  # GET /users/:id/events/:event_id - events#show
    if event = Events.get_event(acc_id, user_id, event_id) do
      send_okay(conn, event)
    else
      send_not_found(conn, %{"status" => 404, "message" => "Event not found."})
    end
  end


  
  #
  ## KEEP THIS AT THE BOTTOM OR IT MATCHES BEFORE OTHER ROUTES and 404's EVERYTHING!!
  #
  match _ do
    send_resp(conn, 404, "oops")
  end

end