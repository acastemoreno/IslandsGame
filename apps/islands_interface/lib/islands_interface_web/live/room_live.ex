defmodule IslandsInterfaceWeb.RoomLive do
  use IslandsInterfaceWeb, :live_view

  alias IslandsInterface.Accounts
  alias IslandsInterfaceWeb.Presence
  alias IslandsInterface.PubSub

  @presence "room:presence"

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    current_user = Accounts.get_user(user_id)

    if connected?(socket) do
      {:ok, _presence} =
        Presence.track(
          self(),
          @presence,
          user_id,
          %{
            id: current_user.id,
            name: current_user.name
          }
        )

      Phoenix.PubSub.subscribe(PubSub, @presence)
    end

    socket =
      socket
      |> assign(current_user: current_user, users: %{})
      |> handle_joins(Presence.list(@presence))

    {:ok, socket}
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    {
      :noreply,
      socket
      |> handle_leaves(diff.leaves)
      |> handle_joins(diff.joins)
    }
  end

  @impl true
  def render(assigns) do
    ~L"""
      <h2><%= @current_user.name %></h2>
      <% IO.inspect(@users) %>
      <ul>
      <%= for {_user_id, user} <- @users do %>
        <%= if user.id == @current_user.id do %>
          <li><%= user[:name] %> (me)</li>
        <% else %>
          <li><%= user[:name] %></li>
        <% end %>
      <% end %>
      </ul>
    """
  end

  defp handle_joins(socket, joins) do
    Enum.reduce(joins, socket, fn {user, %{metas: [meta | _]}}, socket ->
      assign(socket, :users, Map.put(socket.assigns.users, user, meta))
    end)
  end

  defp handle_leaves(socket, leaves) do
    Enum.reduce(leaves, socket, fn {user, _}, socket ->
      assign(socket, :users, Map.delete(socket.assigns.users, user))
    end)
  end
end
