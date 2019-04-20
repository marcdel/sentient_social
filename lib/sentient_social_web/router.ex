defmodule SentientSocialWeb.Router do
  use SentientSocialWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SentientSocialWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SentientSocialWeb do
    pipe_through :browser

    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/favorites", FavoriteController, only: [:create]
    resources "/search_terms", SearchTermController, only: [:create]
    get "/", PageController, :index
  end

  scope "/auth", SentientSocialWeb do
    pipe_through(:browser)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SentientSocialWeb do
  #   pipe_through :api
  # end
end
