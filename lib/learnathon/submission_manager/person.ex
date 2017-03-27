defmodule Learnathon.SubmissionManager.Person do
  use Learnathon.Web, :model
  alias Ecto.Changeset
  alias Learnathon.{
    SubmissionManager.Person, Repo, SubmissionManager.ConfirmationCode}

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

    has_many :confirmation_codes, ConfirmationCode
  end

  def changeset(person, params \\ %{}) do
    person
    |> cast(params, permitted_attributes())
    |> cast_assoc(:confirmation_codes, required: false)
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> validate_format(:email, email_format_regex())
  end

  defp confirmation_code_presence(changeset) do
    case Repo.get_by ConfirmationCode, email: changeset.email do
      nil -> changeset
      _ -> add_error(
              changeset,
              :confirmation_code,
              """
              You have already been sent a confirmation code.
              Please check your spam filters or wait a few minutes
              before trying again. Your existing Confirmation Code must expire
              first before we can send you another one.
              """
            )
    end
  end

  def confirmed?(person) do
    person.confirmed == true
  end

  def new(attributes) do
    changeset(%Person{}, attributes)
  end

  def last_created_confirmation_code(person) do
    case length(person.confirmation_codes) do
      0 -> create_confirmation_code(person)
      _ -> List.last(person.confirmation_codes)
    end
    List.last(person.confirmation_codes)
  end

  defp create_confirmation_code(person) do
      Ecto.
      build_assoc(
        person, 
        :confirmation_codes,
        body: ConfirmationCode.generate) |> Repo.insert!
  end


  defp permitted_attributes do
    [:name, :email, :workshop_idea, :time_needed, :company, :contribution, 
     :donation, :swag, :prizes, :confirmed]
  end

  defp email_format_regex do
    ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  end

end
