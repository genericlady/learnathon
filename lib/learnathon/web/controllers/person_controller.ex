defmodule Learnathon.Web.PersonController do
  use Learnathon.Web, :controller
  alias Learnathon.{SubmissionManager, SubmissionManager.Person}

  action_fallback Learnathon.Web.FallbackController
  plug :authenticate_person when action in [:index, :show, :update, :create, 
                                            :delete, :new]

  def new(conn, _params) do
    changeset = SubmissionManager.person_changeset(%Person{})
    conn |> render("new.html", changeset: changeset)
  end

  def index(conn, _params) do
    people = Repo.all(Learnathon.SubmissionManager.Person)
    render conn, "index.html", people: people
  end

  def show(conn, %{"id" => id}) do
    with {:ok, person} <- Learnathon.SubmissionManager.fetch_person(id) do
      conn |> render("show.html", person: person)
    end
  end

  def create(conn, %{"person" => person_params}) do
    with {:ok, person} <- SubmissionManager.register_person(person_params) do
      conn
      |> Learnathon.Auth.login(person)
      |> put_flash(:info, "#{person.name} created!")
      |> redirect(to: person_path(conn, :index))
    end
  end

end
