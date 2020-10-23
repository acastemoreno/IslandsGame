defmodule IslandsInterfaceWeb.Router do
  use IslandsInterfaceWeb, :router

  alias IslandsInterfaceWeb.Plugs.{
    SetCurrentUser,
    ForceExistingCurrentUser,
    ForceNotExistingCurrentUser
  }

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {IslandsInterfaceWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SetCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :force_auth do
    plug ForceExistingCurrentUser
  end

  pipeline :force_not_auth do
    plug ForceNotExistingCurrentUser
  end

  scope "/", IslandsInterfaceWeb do
    pipe_through :browser

    get "/", PageController, :index

    scope "/" do
      pipe_through :force_not_auth

      get "/login", SessionController, :show_login
      post "/login", SessionController, :create_session

      live "/login-live", LoginLive, :index
    end

    scope "/" do
      pipe_through :force_auth

      delete "/logout", SessionController, :logout

      live "/room", RoomLive, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", IslandsInterfaceWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: IslandsInterfaceWeb.Telemetry
    end
  end
end
