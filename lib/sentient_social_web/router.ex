defmodule SentientSocialWeb.Router do
  use SentientSocialWeb, :router

  import Plug.BasicAuth
  import Phoenix.LiveDashboard.Router

  @admin_name Application.get_env(:sentient_social, :admin_name)
  @admin_password Application.get_env(:sentient_social, :admin_password)

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admins_only do
    plug :basic_auth, username: @admin_name, password: @admin_password
  end

  scope "/", SentientSocialWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/dashboard"
  end

  # Other scopes may use custom stacks.
  # scope "/api", SentientSocialWeb do
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
      live_dashboard "/dashboard", metrics: SentientSocialWeb.Telemetry
    end
  end
end
