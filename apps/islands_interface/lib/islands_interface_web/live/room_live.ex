defmodule IslandsInterfaceWeb.RoomLive do
  use IslandsInterfaceWeb, :live_view

  alias IslandsInterface.Accounts
  alias IslandsInterfaceWeb.Presence
  alias IslandsInterface.PubSub
  alias IslandsInterfaceWeb.GameLive

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

      # Subcribe to users conected
      Phoenix.PubSub.subscribe(PubSub, @presence)
      # Subcribe to challenge
      Phoenix.PubSub.subscribe(PubSub, topic_challenge(user_id))
    end

    socket =
      socket
      |> assign(current_user: current_user, users: %{}, challenged: "")
      |> handle_joins(Presence.list(@presence))

    {:ok, socket}
  end

  @impl true
  def handle_event("challenge", %{"oponent-id" => oponent_id}, socket) do
    Phoenix.PubSub.broadcast(PubSub, topic_challenge(oponent_id), %{
      event: "challenge_recive",
      challenging_id: socket.assigns.current_user.id
    })

    Phoenix.PubSub.subscribe(PubSub, topic_challenge(oponent_id))

    {:noreply, socket}
  end

  def handle_event("decline-challenge", _params, socket) do
    socket =
      socket
      |> assign(challenged: "")

    {:noreply, socket}
  end

  def handle_event("accept-challenge", %{"oponent-id" => oponent_id}, socket) do
    Phoenix.PubSub.broadcast(PubSub, topic_challenge(socket.assigns.current_user.id), %{
      event: "challenge_acepted",
      players: [socket.assigns.current_user.id, oponent_id]
    })

    {:noreply, socket |> assign(:challenged, "")}
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

  def handle_info(%{event: "challenge_recive", challenging_id: challenging_id}, socket) do
    socket =
      socket |> update_socket_challenge_recived(socket.assigns.current_user.id, challenging_id)

    {:noreply, socket}
  end

  def handle_info(%{event: "challenge_acepted", players: players}, socket) do
    id_oponent = id_oponent(socket.assigns.current_user.id, players)

    socket =
      socket
      |> push_redirect(to: Routes.game_path(socket, :index, opponent_id: id_oponent))

    {:noreply, socket}
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

  defp topic_challenge(user_id) do
    "challenge:#{user_id}"
  end

  defp update_socket_challenge_recived(socket, current_user_id, current_user_id) do
    socket
  end

  defp update_socket_challenge_recived(socket, _current_user_id, challenger_id) do
    socket
    |> assign(challenged: challenger_id)
  end

  defp id_oponent(currente_user_id, players_id) do
    Enum.find(players_id, &(&1 !== currente_user_id))
  end
end
