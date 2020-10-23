defmodule IslandsInterfaceWeb.PageController do
  use IslandsInterfaceWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: Routes.login_path(conn, :index))
  end
end
