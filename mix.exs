defmodule Learnathon.Mixfile do
  use Mix.Project

  def project do
    [app: :learnathon,
     version: "0.0.1",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Learnathon.Application, []},
      extra_applications: 
      [
        :elixir_linter,
        :logger,
        :runtime_tools,
        :ecto,
        :postgrex,
        :bamboo,
        :sparkpost,
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0-rc"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:mailgun, "~> 0.1.2"},
      {:poison, "~> 2.1", override: true},
      {:elixir_linter, "~> 0.1.0"},
      {:bamboo, github: "thoughtbot/bamboo", override: true},
      {:ex_machina, "~> 2.0", only: :test},
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:sparkpost, "~> 0.3.0"},
      {:bamboo_sparkpost, "~> 0.5.0"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
