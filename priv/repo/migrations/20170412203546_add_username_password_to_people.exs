defmodule Learnathon.Repo.Migrations.AddUsernamePasswordToPeople do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :username, :string
      add :password_hash, :string
    end

  end
end
