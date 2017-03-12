defmodule Learnathon.Mailer do
  @config domain: Application.get_env(:learnathon, :mailgun_domain),
          key: Application.get_env(:learnathon, :mailgun_key)
          # mode: :test, # Alternatively use Mix.env while in the test environment.
          # test_file_path: "/tmp/mailgun.json"
  use Mailgun.Client, @config

  @from "submissions@learnathon.nyc"

  def send_welcome_email(email_address) do
    send_email to: email_address,
    from: @from,
    subject: "Thank you for your submission to Learnathon!",
    text: welcome_text,
    html: welcome_html
  end

  def send_welcome_text_email(email_address) do
    send_email to: email_address,
    from: "submissions@learnathon.nyc",
    text: welcome_text
  end

  def send_welcome_html_email(email_address) do
    send_email to: email_address,
    from: @from,
    subject: "hello!",
    html: "<strong>Welcome!</strong>"
  end

  # attachments expect a list of maps. Each map should have a filename and path
  # content. (note: this can come in handy for attaching tickets to an email)
  #
  # def send_greetings(user, file_path) do
  #   send_email to: user,
  #   from: @from,
  #   subject: "Happy b'day",
  #   html: "<strong>Cheers!</strong>",
  #   attachments: [%{path: file_path, filename: "greetings.png"}]
  # end

  # def send_invoice(user) do
  #   pdf = Invoice.create_for(user) # a string
  #   send_email to: user,
  #   from: @from,
  #   subject: "Invoice",
  #   html: "<strong>Your Invoice</strong>",
  #   attachments: [%{content: pdf, filename: "invoice.pdf"}]
  # end

  defp welcome_text do
    """
      Thank you so much for your submission! We will keep you informed of any updates as they come up. If you are looking to be a sponsor or run a workshop and selected it in the form we will be in touch. Otherwise you can reply to this email and we will be happy to talk to you about it.
    """
  end

  defp welcome_html do
    Phoenix.View.render_to_string(Learnathon.EmailView, "welcome.html", %{})
  end
end
