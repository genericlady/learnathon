defmodule Learnathon.Web.SubmissionController do
  alias Learnathon.{Person, Repo, Email, Mailer}
  use Learnathon.Web, :controller

  def create(conn, %{"submission" => submission}) do
  # Use `deliver_later` to deliver the email in the background
  # if it errors it won't bring down the app. It's also a little faster
  # you can create a strategy with Bamboo.DeliverLaterStrategy
  #
    case create_person(conn, submission) do
    {:ok, person} ->
      Email.welcome_email(person) |> Mailer.deliver_later
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
