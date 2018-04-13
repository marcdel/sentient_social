defmodule SentientSocialWeb.Router do
  use SentientSocialWeb, :router
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

    get("/login", LoginController, :index)

    scope "/" do
      pipe_through(:login_required)
      get("/", PageController, :index)
      post("/keywords", KeywordsController, :create)
      delete("/keywords/:id", KeywordsController, :delete)
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
