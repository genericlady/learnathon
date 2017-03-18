use Mix.Config

config :learnathon, Learnathon.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DdElx66zpWzWsxNYeQ2oAcZ+wvTNb0tIIA8Ir+jWKBkFTeE+YmkzXRRN7u7ey7Xw",
  render_errors: [view: Learnathon.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Learnathon.PubSub,
           adapter: Phoenix.PubSub.PG2]

