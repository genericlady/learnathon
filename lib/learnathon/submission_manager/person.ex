defmodule Learnathon.SubmissionManager.Person do
  use Learnathon.Web, :model

  schema "people" do
    field :name, :string
    field :email, :string
    field :donation, :string
    field :swag, :string
    field :prizes, :string
    field :workshop_idea, :string
    field :time_needed, :string
    field :company, :string
    field :contribution, :integer
    field :confirmed, :boolean
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :confirmation_codes, Learnathon.SubmissionManager.ConfirmationCode
  end

  def confirmed?(person) do
    person.confirmed == true
  end

end
