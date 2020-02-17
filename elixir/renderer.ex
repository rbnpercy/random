defmodule Rbin.Plugs.Renderer do
  @moduledoc """
    Renderer takes any query response bodies and returns them to the client alongside a Status Code.
  """
  import Plug.Conn

  defimpl Poison.Encoder, for: Any do
    def encode(%{__struct__: _} = struct, options) do
      map = struct
            |> Map.from_struct
            |> sanitize_map
      Poison.Encoder.Map.encode(map, options)
    end

    defp sanitize_map(map) do
      Map.drop(map, [:__meta__, :__struct__])
    end
  end

  @doc """
    Sends the authorised/accepted entity to the renderer.
  """
  @spec send_okay(Plug.Conn.t, term) :: Plug.Conn.t
  def send_okay(conn, entity) do
    conn
    |> send_body(200, entity)
  end

  @doc """
    Sends a creation response.  Will send validation error in future on failure.
  """
  @spec send_create_resp(Plug.Conn.t, term) :: Plug.Conn.t
  def send_create_resp(conn, entity) do
    conn
    |> send_body(201, entity)
  end

  @doc """
    Sends an updated response.
  """
  @spec send_updated(Plug.Conn.t, term) :: Plug.Conn.t
  def send_updated(conn, entity) do
    conn
    |> send_body(200, entity)
  end

  @doc """
    Send an ok response if entity delete was successful.
  """
  @spec send_deleted(Plug.Conn.t, :ok) :: Plug.Conn.t
  def send_deleted(conn, :ok) do
    conn
    |> send_resp(204, "Delete successful..")
  end

  @doc """
    Send an unauthorized 401 response.
  """
  @spec send_unauthorized(Plug.Conn.t) :: Plug.Conn.t
  def send_unauthorized(conn) do
    conn
    |> put_resp_header("www-authenticate", "Token realm=Pezo")
    |> send_resp(401, "")
  end

  @doc """
    Sends a 404 not found status to the renderer.
  """
  @spec send_not_found(Plug.Conn.t, term) :: Plug.Conn.t
  def send_not_found(conn, entity) do
    conn
    |> send_body(404, entity)
  end

  @doc """
    Renders an entity, uses `Poison JSON Decode` and sends it along with a status code.
  """
  @spec send_body(Plug.Conn.t, non_neg_integer, term) :: Plug.Conn.t
  def send_body(conn, status, nil) do
    send_resp(conn, status, "")
  end

  def send_body(conn, status, body) do
    body = Poison.encode!(body, pretty: true)
    content_type = "application/json; charset=utf-8"

    conn
    |> put_resp_header("content-type", content_type)
    |> send_resp(status, body)
  end

end
