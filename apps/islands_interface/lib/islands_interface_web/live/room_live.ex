defmodule IslandsInterfaceWeb.RoomLive do
  use IslandsInterfaceWeb, :live_view

  alias IslandsInterface.{Accounts, Chat}
  alias IslandsInterfaceWeb.Presence
  alias IslandsInterface.PubSub

  @presence "room:presence"

  @chat_topic "room:chat_presences"

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

      # Subcribe to users conected
      Phoenix.PubSub.subscribe(PubSub, @presence)
      # Subcribe to challenge
      Phoenix.PubSub.subscribe(PubSub, @chat_topic)
    end

    {:ok, messages} = Chat.get_messages()

    socket =
      socket
      |> assign(
        current_user: current_user,
        users: %{},
        challenged: "",
        messages: messages
      )
      |> handle_joins(Presence.list(@presence))

    {:ok, socket}
  end

  @impl true
  def handle_event("submit_message", %{"message" => message}, socket) do
    Chat.create_message(socket.assigns.current_user.name, message)

    Phoenix.PubSub.broadcast(PubSub, @chat_topic, %{
      event: "new_message",
      username: socket.assigns.current_user.name,
      message: message
    })

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "new_message", username: username, message: message}, socket) do
    {:noreply,
     socket
     |> update(:messages, fn messages ->
       [%{username: username, message: message} | messages]
     end)}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: diff}, socket) do
    {
      :noreply,
      socket
      |> handle_leaves(diff.leaves)
      |> handle_joins(diff.joins)
    }
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
