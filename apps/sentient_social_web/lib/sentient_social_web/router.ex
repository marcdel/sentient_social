defmodule SentientSocialWeb.Router do
  use SentientSocialWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug

  alias SentientSocialWeb.Plug.Authenticate

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :login_required do
    plug(Authenticate)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SentientSocialWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", LandingPageController, :index)
    get("/login", LoginController, :index)
    post("/login", LoginController, :create)

    scope "/" do
      pipe_through(:login_required)
      get("/dashboard", DashboardController, :index)
      resources("/keywords", KeywordsController, only: [:create, :delete])
      resources("/muted_keywords", MutedKeywordsController, only: [:create, :delete])
    end
  end

  scope "/auth", SentientSocialWeb do
    pipe_through(:browser)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :logout)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SentientSocialWeb do
  #   pipe_through :api
  # end
end
