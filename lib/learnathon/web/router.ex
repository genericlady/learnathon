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
    plug Learnathon.Auth, repo: Learnathon.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Learnathon.Web do
    pipe_through :browser

    get "/skill_level_and_interests", SurveyController, :show
    get "/submission", SubmissionController, :confirm
    post "/submission", SubmissionController, :create
    put "/submission", SubmissionController, :update

    resources "/sessions", SessionController, only: [:new, :create, :delete]

    get "/", PageController, :index
  end

  scope "/", Learnathon.Web do
    pipe_through [:browser, :authenticate_person]
    resources "/people", PersonController, only: [:index, :show, :new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Learnathon.Web do
  #   pipe_through :api
  # end
end
