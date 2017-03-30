defmodule Learnathon.Web.SubmissionController do
  alias Learnathon.{
          SubmissionManager.Person,
          SubmissionManager.ConfirmationCode,
          Repo, 
          Email, 
          Mailer 
        }

  use Learnathon.Web, :controller

  def create(conn, %{"submission" => submission}) do
    changeset = Person.changeset(%Person{}, submission)

    if changeset.valid? do
      person = get_or_insert_person(changeset, conn)
    else
      conn
      |> put_flash(:errors, changeset.errors)
      |> redirect(to: page_path(conn, :index))
    end

    case person.confirmed do
      true ->
        conn
        |> put_flash(:info, "You are already confirmed.")
        |> redirect(to: page_path(conn, :index))
      _ -> false
    end

    confirmation_code_transaction = Repo.transaction fn ->
      Ecto.
      build_assoc(person, 
        :confirmation_codes, 
        body: ConfirmationCode.generate())
      |> Repo.insert!
    end

    email_confirmation_code(Repo.preload(person, :confirmation_codes), conn)
    conn
    |> put_flash(:info, "Check your email for a confirmation message.")
    |> redirect(to: page_path(conn, :index))
  end

  def confirm(conn, _params) do
    update conn, %{"confirmation_code" => _params["confirmation_code"]["body"]}
  end

  def update(conn, %{"confirmation_code" => confirmation_code}) do
    # confirmation code should have validation
    # should always be a specific length
    # maybe log peoples ip so people who abuse it can be black listed
    #
    cc = case Repo.get_by ConfirmationCode, body: confirmation_code do
      nil -> 
        conn
        |> put_flash(:error, confirmation_code_not_found()) 
        |> redirect(to: page_path(conn, :index))
      cc -> cc
    end

    person = Repo.get_by Person, id: cc.person_id
    person = Repo.preload person, :confirmation_codes
    Repo.delete!(cc)

    case confirm(person) do
      {:ok, _person} ->
        conn
        |> put_flash(:info, "You have been confirmed! Thank you!")
        |> redirect(to: page_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, something_went_wrong())
        |> redirect(to: page_path(conn, :index))
    end

  end

  defp confirm(person) do
    changeset = Person.changeset(person, %{confirmed: true})
    Email.confirmation_success(person) |> Mailer.deliver_later
    Repo.update(changeset)
  end

  defp email_confirmation_code(person, conn)do
    Email.confirmation_email(person, conn)
    |> Mailer.deliver_later
  end

  defp get_or_insert_person(changeset, conn) do
    case Repo.get_by(Person, email: changeset.changes.email) do
      nil -> insert_or_redirect_person(changeset, conn)
      person -> person
    end
  end

  defp insert_or_redirect_person(changeset, conn) do
    case Repo.insert(changeset) do
      {:error, changeset} -> 
        conn
        |> put_flash(:errors, changeset.errors)
        |> redirect(to: page_path(conn, :index))
      {:ok, person} -> person
    end
  end

  defp changeset_contains_email?(changeset) do
    Map.has_key?(changeset, :email)
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
