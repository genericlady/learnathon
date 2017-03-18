use Mix.Config

config :learnathon, Learnathon.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "learnathon_repo",
  username: "learnathon",
  password: System.get_env("LEARNATHON_DB_PW"),
  hostname: "localhost"

