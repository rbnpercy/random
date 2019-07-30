defmodule SimpleQueue do
  use GenServer

  ### GenServer API

  def init(state), do: {:ok, state}

  def handle_call(:deq, _from, [value | state]) do
    {:reply, value, state}
  end

  def handle_call(:deq, _from, []), do: {:reply, nil, []}

  def handle_call(:queue, _from, state), do: {:reply, state, state}


  ##ASYNC:

  def handle_cast({:enq, value}, state) do
    {:noreply, state ++ [value]}
  end


  ### Client API

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def queue, do: GenServer.call(__MODULE__, :queue)
  def enq(value), do: GenServer.cast(__MODULE__, {:enq, value})
  def deq, do: GenServer.call(__MODULE__, :deq)

end
