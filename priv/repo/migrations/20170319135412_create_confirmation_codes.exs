defmodule Learnathon.Repo.Migrations.CreateConfirmationCodes do
  use Ecto.Migration

  def change do
    create table(:confirmation_codes) do
      add :body, :string
      add :email, :string

      timestamps()
    end

    create unique_index(:confirmation_codes, [:email])
  end
end
