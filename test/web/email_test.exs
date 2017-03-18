defmodule Learnathon.EmailTest do
  use ExUnit.Case
  use Bamboo.Test, shared: true
  alias Learnathon.{Person, Email, Mailer}

  test "welcome email" do
    person = %Person{name: "John", email: "person@example.com"}

    email = Email.welcome_email(person)

    assert email.to == person.email
    assert email.subject =~ "Welcome to learnathon.nyc!"
    assert email.html_body =~ "Welcome to learnathon.nyc!"
  end

  test "confirmation email" do
    person = %Person{name: "John", email: "person@example.com"}

    email = Email.confirmation_email(person)

    assert email.to == person.email
    assert email.
            subject =~ "Please confirm your email address for learnathon.nyc!"
    assert email.html_body =~ "https://learnathon.nyc/confirm"
  end

  test "confirmation success email" do
    person = %Person{name: "John", email: "person@example.com"}

    email = Email.confirmation_success(person)

    assert email.to == person.email
    assert email.subject =~ "You have been confirmed for learnathon.nyc!"
    assert email.html_body =~ "Thanks for confirming your email!"
  end

  test "after registering, the person gets a confirmation email" do
    person = %Person{name: "John", email: "person@example.com"}
    Email.confirmation_email(person) |> Mailer.deliver_later

    assert_delivered_email Email.confirmation_email(person)
  end
end
