defmodule Learnathon.SubmissionManager do
  @moduledoc """
  The boundary for the SubmissionManager system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Learnathon.Repo
  alias Learnathon.SubmissionManager.Person

  @doc """
  Returns a list of people.

  ## Examples

    iex> list_people()
    [%People{}, ...]

  """
  def list_people do
    Repo.all(Person)
  end

  @doc """
  Gets a person.

  Raises `Ecto.NoResultsError` if the Person does not exist

  ## Examples

      iex> get_person!(1)
      %Person{}

      iex> get_person!(2)
      ** (Ecto.NoResultsError)

  """

  def get_person!(id), do: Repo.get!(Person, id)

  @doc """
  Creates a person

  ## Examples
  
    iex> create_person(%{name: "sally", email: "sally@gmail.com"})
    {:ok, %Person{}}

    iex> create_person(%{name: nil, email: nil})
    {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}) do
    %Person{}
    |> person_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{name: "lupa"})
      {:ok, %Person{}}

      iex> update_person(person, %{name: nil})
      {:error, %Ecto.Changeset{}}

  """

  def update_person(%Person{} = person, attrs) do
    person
    |> person_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.
  
  ## Examples
  
      iex> change_person(person)
      %Ecto.Changeset{confirmed: true}

  """

  def change_person(%Person{} = person) do
    person_changeset(person, %{})
  end

  defp person_changeset(%Person{} = person, attrs) do
    person
    |> cast(attrs, person_permitted_attributes())
    |> validate_required([:name, :email])
  end

  defp person_permitted_attributes do
    [:name, :email, :workshop_idea, :time_needed, :company, :contribution, 
    :donation, :swag, :prizes, :confirmed]
  end
end
