defmodule Learnathon.Person do
  use Ecto.Schema
  alias Ecto.Changeset
  alias Learnathon.Person

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
  end

  def changeset(person, params \\ %{}) do
    person
    |> Changeset.cast(params, permitted_attributes())
    |> Changeset.validate_required([:name, :email])
    |> Changeset.unique_constraint(:email)
    |> Changeset.validate_format(:email, email_format_regex())
  end

  def confirmed?(person) do
    IO.inspect person
    person.confirmed == true
  end

  def new(attributes) do
    changeset(%Person{}, attributes)
  end

  defp permitted_attributes do
    [:name, :email, :workshop_idea, :time_needed, :company, :contribution, 
     :donation, :swag, :prizes, :confirmed]
  end

  defp email_format_regex do
    ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  end

end
