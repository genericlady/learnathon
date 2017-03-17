defmodule Learnathon.Repo.Migrations.AddSponsorFieldsToPerson do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :donation, :string
      add :swag, :string
      add :prizes, :string
    end
  end
end
