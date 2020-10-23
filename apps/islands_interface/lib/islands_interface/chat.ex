defmodule IslandsInterface.Chat do
  use GenServer

  def start_link(_options), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def get_messages(),
    do: GenServer.call(__MODULE__, :get_messages)

  def create_message(username, message),
    do: GenServer.call(__MODULE__, {:create_message, username, message})

  @impl true
  def init(_state) do
    {:ok, []}
  end

  @impl true
  def handle_call({:create_message, username, message}, _from, state) do
    new_message = %{username: username, message: message}
    {:reply, {:ok, new_message}, [new_message | state]}
  end

  @impl true
  def handle_call(:get_messages, _from, state) do
    {:reply, {:ok, state}, state}
  end
end
