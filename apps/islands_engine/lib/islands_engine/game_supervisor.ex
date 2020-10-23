defmodule IslandsEngine.GameSupervisor do
  use DynamicSupervisor

  alias IslandsEngine.Game

  def start_link(_options), do: DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def start_game(name) do
    spec = {Game, name}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def stop_game(name) do
    case pid_from_name(name) do
      pid when is_pid(pid) ->
        DynamicSupervisor.terminate_child(__MODULE__, pid_from_name(name))
      _ ->
        {:error, :no_existing_game}
    end

  end

  def init(:ok), do: DynamicSupervisor.init(strategy: :one_for_one)

  defp pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.whereis()
  end
end
