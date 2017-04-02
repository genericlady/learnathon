defmodule Learnathon.SubmissionManager.ConfirmationCode do
  use Learnathon.Web, :model

  schema "confirmation_codes" do
    field :body, :string
    field :email, :string
    belongs_to :person, Learnathon.SubmissionManager.Person

    timestamps()
  end

  def changeset(confirmation_code, params \\ %{}) do
    confirmation_code
    |> cast(params, [:email, :body, :person_id])
    |> put_assoc(:person, required: true)
    |> validate_required([:body])
  end

  def expired?(confirmation_code) do
    diff_in_seconds(confirmation_code) < negative_fifteen_minutes_in_seconds()
  end

  defp negative_fifteen_minutes_in_seconds do
    -(15 * 60)
  end

  defp diff_in_seconds(confirmation_code) do
    confirmation_code.
      inserted_at
      |> NaiveDateTime.diff(time_now(), :second)
  end

  defp time_now do
    DateTime.utc_now |> DateTime.to_naive
  end
end
