defmodule Learnathon.EmailTest do
  use ExUnit.Case
  use Learnathon.Web.ConnCase
  use Bamboo.Test, shared: true
  alias Learnathon.{Email, Mailer}
  import Learnathon.Factory

  test "welcome email" do
    person = build(:person)

    email = Email.welcome_email(person)

    assert email.to == person.email
    assert email.subject =~ "Welcome to learnathon.nyc!"
    assert email.html_body =~ "Welcome to learnathon.nyc!"
  end

  test "confirmation email", %{conn: conn} do
    person = build(:person)

    email = Email.confirmation_email(person, conn)
    cc = Learnathon.
          SubmissionManager.Person.last_created_confirmation_code(person)

    assert email.to == person.email
    assert email.
            subject =~ "Please confirm your email address for learnathon.nyc!"
    assert email.html_body =~ cc.body
  end

  test "confirmation success email" do
    person = build(:person)

    email = Email.confirmation_success(person)

    assert email.to == person.email
    assert email.subject =~ "You have been confirmed for learnathon.nyc!"
    assert email.html_body =~ "Thanks for confirming your email!"
  end

  test "after registering, the person gets a confirmation email", %{conn: conn} do
    person = build(:person)
    Email.confirmation_email(person, conn) |> Mailer.deliver_later

    assert_delivered_email Email.confirmation_email(person, conn)
  end
end
