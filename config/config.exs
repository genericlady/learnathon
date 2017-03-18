use Mix.Config

config :learnathon, ecto_repos: [Learnathon.Repo]

import_config "repo.exs"
import_config "web_endpoint.exs"
import_config "mailer.exs"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. e.g., test.exs, dev.exs, prod.exs
import_config "#{Mix.env}.exs"

config :elixir_linter, github_oauth_token: System.get_env("GITHUB_TOKEN")
