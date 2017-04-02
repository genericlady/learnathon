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
                                  ]

  action_fallback Learnathon.Web.FallbackController

  def create(conn, %{"submission" => submission}) do

    with {:ok, %Person{} = person} <- get_or_create_person(submission),
         {:ok, %ConfirmationCode{} = confirmation} <- create_person_confirmation(person) do

      conn
      |> put_flash(:info, "Check your email for a confirmation message.")
      |> email_confirmation(person, confirmation)
      |> redirect(to: page_path(conn, :index))
    end

  end

  def confirm(conn, params) do
    if Map.has_key?(params, :body) && (length(params.body) == 64) do
      update conn, %{"confirmation_code" => params["confirmation_code"]["body"]}
    end
  end

  def update(conn, %{"confirmation_code" => confirmation_code}) do
    with {:ok, confirmation_code} <-
           SubmissionManager.get_confirmation_code(confirmation_code),
         {:ok, person} <- SubmissionManager.confirm_person(confirmation_code) do

      email_thank_you(person)

      conn
      |> put_flash(:info, "You have been confirmed! Thank you!")
      |> redirect(to: page_path(conn, :index))
    end
  end

  defp email_thank_you(person) do
    Email.confirmation_success(person) |> Mailer.deliver_now
  end

  defp email_confirmation(conn, person, confirmation) do
    Email.confirmation_email(person, confirmation, conn)
    |> Mailer.deliver_now

    conn
  end

end
