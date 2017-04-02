use Mix.Config

#
# LocalAdapter is for previewing the sent emails at `/sent_emails`
# adapter: Bamboo.LocalAdapter,
config :learnathon, Learnathon.Mailer,
       adapter: Bamboo.SparkPostAdapter,
       api_key: System.get_env("SPARKPOST")

