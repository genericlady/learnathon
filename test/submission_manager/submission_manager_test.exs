defmodule Learnathon.SubmissionManagerTest do
  import Learnathon.Factory
  use Learnathon.DataCase

  alias Learnathon.{SubmissionManager,
                    SubmissionManager.Person,
                    SubmissionManager.ConfirmationCode,}

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

  test "fetch_person returns a tuple with a person {:ok, person}" do
    person = insert(:person_no_code)
    assert SubmissionManager.fetch_person(person.id) == {:ok, person}
  end

  test "fetch_person returns a tuple with a person {:error, person}" do
    assert SubmissionManager.fetch_person(1) == {:error, :not_found}
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
    assert {:ok, person} = 
      SubmissionManager.update_person(person, @update_attrs)
    assert %Person{} = person
    assert person.confirmed == true
  end

  test "update_person/2 with invalid data returns error changeset." do
    person = insert(:person_no_code)
    assert {:error, %Ecto.Changeset{}} = 
      SubmissionManager.update_person(person, @invalid_attrs)
    assert person == SubmissionManager.get_person!(person.id)
  end

  describe "person_changeset/2 returns a Changeset" do
    @valid_person_changeset %{name: "sam", email: "sam@gmail.com"}
    @invalid_person_changeset %{name: "sam"}

    test "given valid input it will return a usable changeset." do
      changeset = 
        SubmissionManager.person_changeset %Person{}, @valid_person_changeset

      assert changeset.valid? == true
    end

    test "given input without email or name returns changeset with errors." do
      changeset = 
        SubmissionManager.person_changeset %Person{}, @invalid_person_changeset

      assert changeset.valid? == false
    end
  end

  describe "confirmation_changeset/2 returns a Confirmation Code Changeset" do
    test "given a map with a body attribute the changeset is validated" do
      confirmation_hash = SubmissionManager.generate_hash()
      changeset = 
        SubmissionManager.
        confirmation_changeset %ConfirmationCode{}, %{body: confirmation_hash}

      assert changeset.valid? == true
    end

    test "given a map without a body attribute the changeset is invalid" do
      changeset = 
        SubmissionManager.
        confirmation_changeset %ConfirmationCode{}, %{body: nil}

      assert changeset.valid? == false
    end

    test "when the body is less than 64 chars the changeset is invalid" do
      confirmation_code = String.duplicate "a", 63
      changeset = 
        SubmissionManager.
        confirmation_changeset %ConfirmationCode{}, %{body: nil}

      assert changeset.valid? == false
    end

    test "when the body is greater than 64 chars the changeset is invalid" do
      confirmation_code = String.duplicate "a", 65
      changeset = 
        SubmissionManager.
        confirmation_changeset %ConfirmationCode{}, %{body: nil}

      assert changeset.valid? == false
    end
  end

  describe "registration_changeset/2 returns a person changeset" do
    test "given a password of at least 6 chars a changeset will be valid." do
      pw = "123456"
      person = build(:person)
      changeset = 
        SubmissionManager.registration_changeset person, %{password: pw}

      assert changeset.valid? == true
    end

    test "given a password of less than 6 chars changeset will be invalid." do
      pw = "123"
      person = build(:person)
      changeset = 
        SubmissionManager.registration_changeset person, %{password: pw}

      assert changeset.valid? == false
    end
  end

  describe "register_person will validate a persons pw and save a pw hash." do
    test "if person does not exist it will insert a person." do
      params = %{name: "sam", email: "samwise@gmail.com", password: "123456"}
      {:ok, registered_person} = SubmissionManager.register_person(params)
      person = Repo.get Person, registered_person.id

      assert person.password_hash != nil
      assert person.id == registered_person.id
    end

    test "if person does exist it will update the person." do
      person = insert(:person_no_code)
      params = %{name: person.name, email: person.email, password: "123456"}

      {:ok, updated_person} = SubmissionManager.register_person(params)

      assert person.id == updated_person.id
      assert person.password_hash == nil
      assert updated_person.password_hash != nil
    end
  end
end
