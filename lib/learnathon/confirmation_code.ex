defmodule Learnathon.ConfirmationCode do
  use Ecto.Schema
  alias Ecto.Changeset

  schema "confirmation_codes" do
    field :body, :string
    field :email, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Changeset.cast(params, [:email, :body])
    |> Changeset.validate_required([:email, :body])
    |> Changeset.unique_constraint(:email)
  end

  def generate do
    :crypto.
      strong_rand_bytes(64)
      |> Base.url_encode64
      |> binary_part(0, 64)
  end
end
