defmodule Learnathon.Web.SubmissionController do
  use Learnathon.Web, :controller
  alias Learnathon.{Person, Repo}

  def create(conn, %{"submission" => submission}) do
    case create_person(conn, submission) do
    {:ok, _person} ->
      Learnathon.Mailer.send_welcome_text_email(_person.email)
      conn
      |> put_flash(:info, thank_you_message())
      |> redirect(to: page_path(conn, :index))
    {:error, _person} ->
      conn
      |> put_flash(:error, error_message())
      |> redirect(to: page_path(conn, :index))
    end
  end

  defp create_person(conn, attributes) do
    Repo.insert Person.new(attributes)
  end

  defp thank_you_message do
    "Thank you for your submission! We will keep you up to date with changes!"
  end

  defp error_message do
    "There was an error, try again. If you're trying to update your submission 
    please reach out to us ( submissions at learnathon.nyc )"
  end
end
