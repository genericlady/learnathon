defmodule Learnathon.Web.SessionController do
  use Learnathon.Web, :controller
  alias Learnathon.Repo

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pw}}) do
    case Learnathon.Auth.login_by_email_and_pass(conn, email, pw, repo: Repo) do
      {:ok, conn} -> 
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} -> 
        conn
        |> put_flash(:error, "Invalid email and/or password combo.")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Learnathon.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
