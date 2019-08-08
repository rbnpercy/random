defmodule Luno.Plugs.Exceptions do
  @moduledoc """
    Plug extension for Exception handling relating to HTTP response codes.
  """

  @doc """
    Any of these Exceptions can be imported via `alias Luno.Plug.*ExceptionName*` etc. 
  """
  defmodule BadRequest do
    defexception [message: "Bad Request"]

    defimpl Plug.Exception do
      def status(_exception) do
        400
      end
    end
  end

  defmodule NotFound do
    defexception [message: "Not Found"]

    defimpl Plug.Exception do
      def status(_exception) do
        404
      end
    end
  end

  defmodule RequestTimeout do
    defexception [message: "Request Timeout"]

    defimpl Plug.Exception do
      def status(_exception) do
        408
      end
    end
  end

  defmodule RequestTooLarge do
    defexception [message: "Request Entity Too Large"]

    defimpl Plug.Exception do
      def status(_exception) do
        413
      end
    end
  end
end
