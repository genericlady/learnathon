defmodule Learnathon.Repo.Migrations.AddConfirmedFieldToPerson do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :confirmed, :boolean
    end
  end
end
