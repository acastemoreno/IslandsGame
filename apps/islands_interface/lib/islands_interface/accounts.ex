defmodule IslandsInterface.Accounts do
  use GenServer

  def start_link(_options), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def get_user(user_id), do: GenServer.call(__MODULE__, {:get_user, user_id})

  def delete_user(user_id), do: GenServer.call(__MODULE__, {:delete_user, user_id})

  def validate_user(""), do: {:error, :empty_string}

  def validate_user(username),
    do: GenServer.call(__MODULE__, {:validate_user, String.downcase(username)})

  def create_user(""), do: {:error, :empty_string}

  def create_user(username),
    do: GenServer.call(__MODULE__, {:create_user, String.downcase(username)})

  @impl true
  def init(_state) do
    {:ok, %{users: [], count: 0}}
  end

  @impl true
  def handle_call({:get_user, user_id}, _from, %{users: users} = state) do
    user = Enum.find(users, &(&1.id === user_id))

    {:reply, user, state}
  end

  @impl true
  def handle_call({:delete_user, user_id}, _from, %{users: users} = state) do
    user = Enum.find(users, &(&1.id === user_id))

    {:reply, user, update_in(state, [:users], &List.delete(&1, user))}
  end

  @impl true
  def handle_call({:validate_user, username}, _from, %{users: users} = state) do
    case Enum.any?(users, &check_username(&1, username)) do
      true ->
        {:reply, {:error, :user_already_exist}, state}

      false ->
        {:reply, :ok, state}
    end
  end

  def handle_call({:create_user, username}, _from, %{users: users, count: count} = state) do
    case Enum.any?(users, &check_username(&1, username)) do
      true ->
        {:reply, {:error, :user_already_exist}, state}

      false ->
        user = %{name: username, id: count + 1}
        {:reply, {:ok, user}, %{users: [user | users], count: count + 1}}
    end
  end

  defp check_username(user, username) do
    user.name === username
  end
end
