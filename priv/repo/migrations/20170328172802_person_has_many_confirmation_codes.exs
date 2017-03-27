defmodule Learnathon.Repo.Migrations.PersonHasManyConfirmationCodes do
  use Ecto.Migration

  def change do
    alter table(:confirmation_codes) do
      add :person_id, :integer
    end
  end
end
