defmodule Learnathon.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias Learnathon.{SubmissionManager.Person,
                    Web.Router.Helpers,}

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    person_id = get_session(conn, :person_id)
    person = person_id && repo.get(Person, person_id)
    assign(conn, :current_person, person)
  end

  def login(conn, person) do
    conn
    |> assign(:current_person, person)
    |> put_session(:person_id, person.id)
    |> configure_session(renew: true)
  end

  def login_by_email_and_pass(conn, email, pw, opts) do
    repo = Keyword.fetch!(opts, :repo)
    person = repo.get_by(Person, email: email)

    cond do
      person && checkpw(pw, person.password_hash) ->
        {:ok, login(conn, person)}
      person ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_person(conn, _opts) do
    if conn.assigns.current_person do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page.")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end

end
