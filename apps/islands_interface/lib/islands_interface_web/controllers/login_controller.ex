defmodule IslandsInterfaceWeb.LoginController do
  use IslandsInterfaceWeb, :controller

  alias IslandsInterface.Accounts

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"name" => name}) do
    case Accounts.create_user(name) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, _error_message} ->
        conn
        |> put_flash(:info, "Error loggin")
        |> render("index.html")
    end
  end
end
