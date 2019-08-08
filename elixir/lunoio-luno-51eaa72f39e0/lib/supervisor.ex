defmodule Luno.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts)
  end

  def init(opts) do
    Logger.info "Starting Cowboy on port #{opts[:port]}"

    tree = [
      # worker(Luno.Worker, []),
      Plug.Adapters.Cowboy.child_spec(:http, Luno.Router, [], opts)
    ]
    supervise(tree, strategy: :one_for_one)
  end
end