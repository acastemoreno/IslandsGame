defmodule IslandsInterfaceWeb.RoomLive do
  use IslandsInterfaceWeb, :live_view

  def mount(_parmas, session, socket) do
    IO.inspect(session)
    {:ok, assign_new(socket, :current_user, fn -> 1 end)}
  end

  def render(assigns) do
    ~L"""

    """
  end
end
