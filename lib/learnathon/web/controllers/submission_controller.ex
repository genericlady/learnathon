defmodule Learnathon.Web.SubmissionController do
  use Learnathon.Web, :controller

  alias Learnathon.{
          SubmissionManager,
          SubmissionManager.Person,
          SubmissionManager.ConfirmationCode,
          Email, 
          Mailer 
        }

  import SubmissionManager, only: [
                                    get_or_create_person: 1,
                                    create_person_confirmation: 1,
                                    get_confirmation_code: 1,
                                    confirm_person: 1,
                                  ]

  action_fallback Learnathon.Web.FallbackController

  def create(conn, %{"submission" => submission}) do

    with {:ok, %Person{} = person} <- get_or_create_person(submission),
         {:ok, %ConfirmationCode{} = confirmation} <- create_person_confirmation(person) do

      email_confirmation(conn, person, confirmation)

      conn
      |> put_flash(:info, "Check your email for a confirmation message.")
      |> redirect(to: page_path(conn, :index))
    end

  end

  def confirm(conn, params) do
    with {:ok, params} <- validate_confirmation_params(params) do
      update conn, %{"confirmation_code" => params["submission"]}
    end
  end

  def update(conn, %{"confirmation_code" => confirmation_code}) do
    with {:ok, confirmation_code} <- get_confirmation_code(confirmation_code),
         {:ok, person} <- confirm_person(confirmation_code) do

      email_thank_you(person)

      conn
      |> put_flash(:info, "You have been confirmed! Thank you!")
      |> redirect(to: page_path(conn, :index))
    end
  end

  defp validate_confirmation_params(params) do
    IO.inspect params["submission"]
    if (String.length(params["submission"]) == 64) do
      {:ok, params}
    else
      {:error, "🕵️‍ confirmation code invalid, cut the bologney! 🕵️‍"}
    end
  end

  defp email_thank_you(person) do
    Email.confirmation_success(person)
    # |> Mailer.deliver_now
  end

  defp email_confirmation(conn, person, confirmation) do
    Email.confirmation_email(person, confirmation, conn)
    # |> Mailer.deliver_later
  end

end
