defmodule Learnathon.Confirmation do
  import Learnathon.Factory

  alias Learnathon.{Email, SubmissionManager.Person}

  use ExUnit.Case
  use Learnathon.Web.ConnCase
  use Bamboo.Test

  test "Confirmation email", %{conn: conn} do
    person = build(:person)
    email = Email.confirmation_email(person, conn)

    assert email.to == person.email
    assert email.html_body =~ "Please confirm your email"

    confirmation_code = Person.last_created_confirmation_code(person)
    assert email.html_body =~ confirmation_code.body
  end

  test "After confirmation the person gets a thank you email.", %{conn: conn} do
    person = insert(:person)
    cc = Person.last_created_confirmation_code(person)
    put(conn, submission_path(conn, :update), confirmation_code: cc.body)

    assert_delivered_email Learnathon.Email.confirmation_success(person)
  end
end
