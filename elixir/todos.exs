defmodule Tasks do
  use GenServer

  ### GenServer API

  def init(state), do: {:ok, state}

  def handle_call(:done, _from, [value | state]) do
    {:reply, value, state}
  end

  def handle_call(:done, _from, []), do: {:reply, nil, []}

  def handle_call(:list, _from, state), do: {:reply, state, state}


  ## ASYNC

  def handle_cast({:push, value}, state) do
    {:noreply, state ++ [value]}
  end

  ## CLIENT API

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def list, do: GenServer.call(__MODULE__, :list)
  def push(value), do: GenServer.cast(__MODULE__, {:push, value})
  def done, do: GenServer.call(__MODULE__, :done)

end
