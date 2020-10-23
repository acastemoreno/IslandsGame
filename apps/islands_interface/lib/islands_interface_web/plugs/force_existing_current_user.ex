defmodule IslandsInterfaceWeb.Plugs.ForceExistingCurrentUser do
  import Plug.Conn

  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias IslandsInterfaceWeb.Router.Helpers, as: Routes

  alias IslandsInterface.Accounts

  def init(opts), do: opts
  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.login_path(conn, :index))
      |> halt()
    end
  end
end