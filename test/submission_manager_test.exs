defmodule Learnathon.SubmissionManagerTest do
  import Learnathon.Factory
  use Learnathon.DataCase

  alias Learnathon.SubmissionManager
  alias Learnathon.SubmissionManager.Person

  @create_attrs %{name: "Sally", email: "sally@gmail.com"}
  @update_attrs %{confirmed: true}
  @invalid_attrs %{name: nil, email: nil}

  test "list_people/1 returns all people" do
    person = insert(:person_no_code)
    assert SubmissionManager.list_people() == [person]
  end

  test "get_person! returns the person with given id" do
    person = insert(:person_no_code)
    assert SubmissionManager.get_person!(person.id) == person
  end

  test "get_person! Raises `NoResultsError` if the Person does not exist" do
    assert_raise Ecto.NoResultsError, fn ->
      SubmissionManager.get_person!(100)
    end
  end

  test "get_person returns the person with given id" do
    person = insert(:person_no_code)
    assert SubmissionManager.get_person(person.id) == person
  end

  test "get_person returns nil if the Person does not exist" do
    assert SubmissionManager.get_person(100) == nil
  end

  test "create_person/1 with valid data creates a person." do
    assert {:ok, %Person{}} = SubmissionManager.create_person(@create_attrs)
  end

  test "create_person/1 with invalid data returns error changeset." do
    assert {:error, %Ecto.Changeset{}} = 
      SubmissionManager.create_person(@invalid_attrs)
  end

  test "get_or_create_person/1 with valid data returns a person if they exist." do
    person = insert(:person)
    changeset = SubmissionManager.
                person_changeset(%Person{}, %{name: person.name, email: person.email})
    {:ok, found_person} = SubmissionManager.get_or_create_person(changeset.changes)

    assert person.name == found_person.name
  end

  test "get_or_create_person/1 with valid data returns a person if they do not exist." do
    changeset = SubmissionManager.
                person_changeset(%Person{}, %{name: "tom", email: "tom@fun.com"})
    {:ok, person} = SubmissionManager.get_or_create_person(changeset.changes)

    assert "tom" == person.name
  end

  test "create_confirmation/1 
          with a person struct will create an associated confirmation code" do

    person = build(:person_no_code)
    SubmissionManager.create_person_confirmation(person)
  end

  test "delete_all_confirmation_codes_for_person/1 
          deletes all confirmation codes associated with person." do
    person = insert(:person)
             |> SubmissionManager.delete_all_confirmation_codes_for_person
             |> Repo.preload(:confirmation_codes)
    assert length(person.confirmation_codes) == 0
  end

  test "generate_hash/0 will generate a 64 byte string hash" do
    hash = SubmissionManager.generate_hash()
    assert String.length(hash) == 64
  end

  test "get_confirmation_code" do
  end

  test "update_person/2 with valid data updates the person." do
    person = insert(:person)
    assert {:ok, person} = SubmissionManager.update_person(person, @update_attrs)
    assert %Person{} = person
    assert person.confirmed == true
  end

  test "update_person/2 with invalid data returns error changeset." do
    person = insert(:person_no_code)
    assert {:error, %Ecto.Changeset{}} = 
      SubmissionManager.update_person(person, @invalid_attrs)
    assert person == SubmissionManager.get_person!(person.id)
  end

  test "create_confirmation_code/1 with valid data creates a confirmation code" do
  end

  test "delete_confirmation_code/1 deletes the confirmation_code" do
  end

end
