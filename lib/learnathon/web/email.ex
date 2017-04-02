defmodule Learnathon.Email do
  import Bamboo.Email
  import Bamboo.Phoenix

  # For Mass Mail see Handling Receipients
  # https://github.com/thoughtbot/bamboo#handling-recipients
  #
  def welcome_email(person) do
    base_email()
    |> to(person.email)
    |> subject("Welcome to learnathon.nyc!")
    |> put_header("Reply-To", "submissions@learnathon.nyc")
    |> html_body(welcome_html())
    |> text_body(welcome_plain())
  end

  def confirmation_email(person, confirmation, conn) do
    base_email()
    |> to(person.email)
    |> subject("Please confirm your email address for learnathon.nyc!")
    |> put_header("Reply-To", "submissions@learnathon.nyc")
    |> html_body(confirmation_html(confirmation, conn))
    |> text_body(confirmation_plain())
  end

  def confirmation_success(person) do
    base_email()
    |> to(person.email)
    |> subject("You have been confirmed for learnathon.nyc!")
    |> put_header("Reply-To", "submissions@learnathon.nyc")
    |> html_body(confirmation_success_html())
    |> text_body(confirmation_success_plain())
  end

  defp base_email do
    new_email()
    |> from("submissions@learanthon.nyc")
    |> put_html_layout({Learnathon.LayoutView, "email.html"})
    |> put_text_layout({Learnathon.LayoutView, "email.txt"})
  end

  defp welcome_html do
    present_email_template("welcome")
  end

  defp welcome_plain do
    present_email_template("welcome_plain")
  end

  defp confirmation_html(confirmation, conn) do
    Phoenix.View.
      render_to_string(
        Learnathon.EmailView, 
        "confirmation.html",
        conn: conn,
        cc: confirmation.body)
  end

  defp confirmation_plain do
    present_email_template("confirmation_plain")
  end

  defp confirmation_success_html do
    present_email_template("confirmation_success")
  end

  defp confirmation_success_plain do
    present_email_template("confirmation_success_plain")
  end

  defp present_email_template(filename) do
    # render_to_string essentially makes it HTML safe to be rendered in view
    # otherwise it thing will be unrendered and show up like <p>thing</p>
    Phoenix.View.
      render_to_string(
        Learnathon.EmailView, "#{filename}.html", %{})
  end
end
