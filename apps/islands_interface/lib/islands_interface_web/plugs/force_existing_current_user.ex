defmodule IslandsInterfaceWeb.Plugs.ForceExistingCurrentUser do
  import Plug.Conn

  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias IslandsInterfaceWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.session_path(conn, :show_login))
      |> halt()
    end
  end
end
