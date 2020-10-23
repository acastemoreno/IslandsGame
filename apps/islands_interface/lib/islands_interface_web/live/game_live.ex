defmodule IslandsInterfaceWeb.GameLive do
  use IslandsInterfaceWeb, :live_view

  def mount(params, session, socket) do
    IO.inspect(params)
    IO.inspect(session)
    {:ok, socket}
  end
end
