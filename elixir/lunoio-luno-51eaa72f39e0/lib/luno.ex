defmodule Luno do
  use Application

  def start(_type, _args) do
    port = Application.get_env(:luno, :port)
    opts = [compress: true, port: String.to_integer(port)]

    config(opts[:port])
    Luno.Supervisor.start_link(opts)
  end

   defp config(port) do
    Application.put_env(:luno, :port, port)
  end 

end
