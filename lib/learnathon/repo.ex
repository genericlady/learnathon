defmodule Learnathon.Repo do
  use Ecto.Repo, otp_app: :learnathon

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Friends.Repo, []),
    ]
  end
end
