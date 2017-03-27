defmodule Learnathon.Web.SubmissionController do
  alias Learnathon.{Person, Repo, Email, Mailer, ConfirmationCode}
  use Learnathon.Web, :controller

  def create(conn, %{"submission" => submission}) do
  # Use `deliver_later` to deliver the email in the background
  # if it errors it won't bring down the app. It's also a little faster
  # you can create a strategy with Bamboo.DeliverLaterStrategy
  #
    case create_person(submission) do
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

  def update(conn, %{"confirmation_code" => confirmation_code}) do
    cc = case Repo.get_by ConfirmationCode, body: confirmation_code.body do
      nil -> 
        conn
        |> put_flash(:error, confirmation_code_not_found()) 
        |> redirect(to: page_path(conn, :index))
      cc -> cc
      _ -> 
        conn
        |> put_flash(:error, confirmation_code_not_found()) 
        |> redirect(to: page_path(conn, :index))
    end

    person = case ConfirmationCode.expired?(cc) do
      :true -> 
        conn
        |> put_flash(:error, "Confirmation Code has expired") 
        |> redirect(to: page_path(conn, :index))
      _ -> Repo.get_by(Person, email: cc.email)
    end

    Repo.delete!(cc)
    changeset = Person.changeset(person, %{confirmed: true})
    case Repo.update(changeset) do
      {:ok, _person} ->
        conn
        |> put_flash(:success, "You have been confirmed! Thank you!")
        |> redirect(to: page_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, something_went_wrong())
        |> redirect(to: page_path(conn, :index))
    end
  end

  defp create_person(attributes) do
    Repo.insert Person.new(attributes)
  end

  defp thank_you_message do
    "Thank you for your submission! We will keep you up to date with changes!"
  end

  defp error_message do
    "There was an error, try again. If you're trying to update your submission 
    please reach out to us ( submissions at learnathon.nyc )"
  end

  defp confirmation_code_not_found do
    """
    Confirmation Code could not be found. It may be expired. Please try your 
    submission again.
    """
  end

  defp something_went_wrong do
    """
    Sorry, something went wrong when you tried to confirm your email. Please 
    contact admin@learnathon.nyc
    """
  end
end
