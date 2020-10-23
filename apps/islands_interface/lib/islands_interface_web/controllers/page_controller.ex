defmodule IslandsInterfaceWeb.PageController do
  use IslandsInterfaceWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: Routes.session_path(conn, :show_login))
  end
end
