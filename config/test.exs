use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :learnathon, Learnathon.Web.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :learnathon, Learnathon.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "learnathon",
  password: System.get_env("LEARNATHON_DB_PW"),
  database: "learnathon_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :learnathon, Learnathon.Mailer,
  adapter: Bamboo.TestAdapter
