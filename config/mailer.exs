use Mix.Config

config :learnathon,
       mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
       mailgun_key: System.get_env("MAILGUN_API_KEY")

# Mailgun adapter has been what we use to actually send emails
# adapter: Bamboo.Mailgun,
#
# LocalAdapter is for previewing the sent emails at `/sent_emails`
# adapter: Bamboo.LocalAdapter,
config :learnathon, Learnathon.Mailer,
       adapter: Bamboo.LocalAdapter,
       api_key: System.get_env("MAILGUN_API_KEY")

