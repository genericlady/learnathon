defmodule Learnathon.PersonTest do
  use Learnathon.ModelCase

  alias Learnathon.Person
  
  @valid_attrs %{name: "foo", email: "cheese@gmail.com"}
  @invalid_attrs %{name: "foo", email: "chee"}

  test "changeset with valid attributes" do
    changeset = Person.changeset(%Person{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Person.changeset(%Person{}, @invalid_attrs)
    refute changeset.valid?
  end
end
