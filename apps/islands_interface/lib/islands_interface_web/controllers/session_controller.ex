defmodule IslandsInterfaceWeb.SessionController do
  use IslandsInterfaceWeb, :controller

  alias IslandsInterface.Accounts

  def show_login(conn, _params) do
    render(conn, "index.html")
  end

  def create_session(conn, %{"name" => name}) do
    case Accounts.create_user(name) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, _error_message} ->
        conn
        |> put_flash(:info, "Error logging")
        |> render("index.html")
    end
  end

  def logout(conn, _params) do
    Accounts.delete_user(conn.assigns.current_user.id)

    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.session_path(conn, :show_login))
  end
end
