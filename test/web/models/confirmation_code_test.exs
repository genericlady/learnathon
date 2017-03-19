defmodule Learnathon.ConfirmationCodeTest do
  use Learnathon.ModelCase

  alias Learnathon.ConfirmationCode

  @valid_attrs %{body: ConfirmationCode.generate, email: "franny@gmail.com"}
  @invalid_attrs %{body: "{&*!@#$)"}

  test "changeset with valid attributes" do
    changeset = ConfirmationCode.changeset(%ConfirmationCode{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ConfirmationCode.changeset(%ConfirmationCode{}, @invalid_attrs)
    refute changeset.valid?
  end
end

