defmodule Learnathon.SubmissionManagerTest do
  import Learnathon.Factory
  use Learnathon.DataCase

  alias Learnathon.SubmissionManager
  alias Learnathon.SubmissionManager.Person

  @create_attrs %{name: "Sally", email: "sally@gmail.com"}
  @update_attrs %{confirmed: true}
  @invalid_attrs %{name: nil, email: nil}

  @workshop_attrs %{workshop_idea: "paper airplanes!"}

  test "list_people/1 returns all people" do
    person = insert(:person_no_code)
    assert SubmissionManager.list_people() == [person]
  end

  test "get_person! returns the person with given id" do
    person = insert(:person_no_code)
    assert SubmissionManager.get_person!(person.id) == person
  end

  test "create_person/1 with valid data creates a person." do
    assert {:ok, %Person{} = person} = 
      SubmissionManager.create_person(@create_attrs)
  end

  test "create_person/1 with invalid data returns error changeset." do
    assert {:error, %Ecto.Changeset{}} = 
      SubmissionManager.create_person(@invalid_attrs)
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
