defmodule IslandsInterfaceWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  alias IslandsInterface.Accounts

  def init(opts), do: opts
  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user(user_id)
    IO.inspect(user)
    assign(conn, :current_user, user)
  end
end