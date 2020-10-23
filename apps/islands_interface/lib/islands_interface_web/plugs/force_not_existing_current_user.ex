defmodule IslandsInterfaceWeb.Plugs.ForceNotExistingCurrentUser do
  import Plug.Conn

  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias IslandsInterfaceWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user do
      conn
      |> put_flash(:error, "You can not access that page for be already logged")
      |> redirect(to: Routes.room_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
