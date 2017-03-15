defmodule Learnathon.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :name, :string
      add :email, :string
      add :workshop_idea, :string
      add :time_needed, :string
      add :company, :string
      add :contribution, :string
    end

    create unique_index(:people, [:email])
  end
end
