defmodule Learnathon.PersonTest do
  use ExUnit.Case
  use Learnathon.ModelCase
  import Learnathon.Factory

  alias Learnathon.{SubmissionManager, SubmissionManager.Person}

  @valid_attrs %{
    name: "sam", username: "sammy", email: "sam@gmail.com", password: "123456"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SubmissionManager.person_changeset(%Person{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SubmissionManager.person_changeset(%Person{}, @invalid_attrs)
    refute changeset.valid?
  end
end
