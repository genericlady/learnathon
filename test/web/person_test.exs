defmodule Learnathon.PersonTest do
  import Learnathon.Factory
  use Learnathon.ModelCase

  alias Learnathon.{
                     SubmissionManager,
                     SubmissionManager.Person
                   }
  
  @valid_attrs %{name: "foo", email: "cheese@gmail.com"}
  @invalid_attrs %{name: "foo", email: "chee"}

  test "changeset with valid attributes" do
    changeset = SubmissionManager.person_changeset(%Person{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SubmissionManager.person_changeset(%Person{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "has the ability to know if it's confirmed?" do
    attrs = %{name: "foo", email: "cheese@gmail.com", confirmed: true}
    person = build(:person, attrs)

    assert Person.confirmed?(person) == true
  end
end
