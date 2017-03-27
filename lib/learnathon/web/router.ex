defmodule Learnathon.Web.Router do
  use Learnathon.Web, :router
  use Phoenix.Router

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

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

  scope "/", Learnathon.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/submission", SubmissionController, :create
    put "/submission", SubmissionController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", Learnathon.Web do
  #   pipe_through :api
  # end
end
