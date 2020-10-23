defmodule IslandsInterfaceWeb.LoginLive do
  use IslandsInterfaceWeb, :live_view

  alias IslandsInterface.Accounts
  alias IslandsInterfaceWeb.PageLive

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, name: "", valid?: true, message_error: "")}
  end

  @impl true
  def handle_event("validate_name", %{"name" => name}, socket) do
    case Accounts.validate_user(name) do
      :ok ->
        {:noreply, assign(socket, name: name, valid?: true, message_error: "")}

      {:error, :empty_string} ->
        {:noreply,
         assign(socket, name: name, valid?: false, message_error: "Empty name is not valid")}

      {:error, :user_already_exist} ->
        {:noreply,
         assign(socket,
           name: name,
           valid?: false,
           message_error: "Username already used, choose another one"
         )}
    end
  end
end
