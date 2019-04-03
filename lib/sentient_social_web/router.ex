defmodule SentientSocialWeb.Router do
  use SentientSocialWeb, :router

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

  scope "/", SentientSocialWeb do
    pipe_through :browser

    resources "/users", UserController, only: [:index, :show, :new, :create]
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", SentientSocialWeb do
  #   pipe_through :api
  # end
end
