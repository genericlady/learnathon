defmodule Learnathon.ConfirmationCodeTest do
  use Learnathon.ModelCase
  import Learnathon.Factory

  alias Learnathon.{
                     SubmissionManager,
                     SubmissionManager.ConfirmationCode, }

  @valid_attrs %{body: SubmissionManager.generate_hash}

  test "changeset with valid attributes" do
    changeset = ConfirmationCode.changeset(%ConfirmationCode{}, @valid_attrs)
    assert changeset.valid?
  end

  test "if younger than 15 minutes expired? returns false" do
    cc = build(:confirmation_code)
    assert ConfirmationCode.expired?(cc) == false
  end

  test "if older than 15 minutes expired? returns true" do
    cc = build(:expired_confirmation_code)

    assert ConfirmationCode.expired?(cc) == true
  end
end

