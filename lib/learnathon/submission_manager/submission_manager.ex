defmodule Learnathon.SubmissionManager do
  @moduledoc """
  The boundary for the SubmissionManager system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Learnathon.{
                     Repo,
                     SubmissionManager,
                     SubmissionManager.Person,
                     SubmissionManager.ConfirmationCode
                   }

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
  Gets a person by id but throws a NoResultsError.

  Raises `Ecto.NoResultsError` if the Person does not exist

  ## Examples

      iex> get_person!(1)
      %Person{}

      iex> get_person!(2)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id), do: Repo.get!(Person, id)

  @doc """
  Gets a person by id.

  Returns `nil` if the Person does not exist

  ## Examples

      iex> get_person(1)
      %Person{}

      iex> get_person(2)
      nil

  """
  def get_person(id), do: Repo.get(Person, id)

  @doc """
  Fetches a person by id.

  Returns `{:ok, person}` or `{:error, person}`

  ## Examples

    iex> fetch_person(1)
    {:ok, %Person{}}

    iex> fetch_person(2)
    {:error, "Person not found."}

  """

  def fetch_person(id) do
    if person = Repo.get(Learnathon.SubmissionManager.Person, id) do
      {:ok, person}
    else
      {:error, :not_found}
    end
  end

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
      %Ecto.Changeset{}

  """
  def change_person(%Person{} = person) do
    person_changeset(person, %{})
  end

  @doc """
  If changeset or map is invalid return changeset with errors.
  If person is found by email then return that Person.
  If person is not found create person.

  ## Examples

      iex> get_or_create_person(changeset)
      {:ok, %Person{name: "sam", email: "sam@gmail.com"}}

      iex> get_or_create_person(%{foo: nil})
      {:errors, changeset}

  """
  def get_or_create_person(submission) do
    changeset = person_changeset(%Person{}, submission)
    if changeset.valid? do
      case Repo.get_by(Person, email: changeset.changes.email) do
        nil -> create_person(changeset.changes)
        person -> {:ok, person}
      end
    else
      {:errors, changeset}
    end
  end

  @doc """
  Register a person by saving a password for authentication.
  - Password must be at least 6 chars.
  - Inserts or Updates specified model.
  - Returns a tuple with an atom of `:ok` and a `Person` struct.
  - If there is an error returns `{:error, changeset}`

    iex> params = %{name: "Seal", email: "seal@gmail.com", password: "123456"}
    iex> {:ok, person} = register_person(params)

    iex> invalid_params = %{name: "Seal", email: "s", password: "12345"}
    iex> {:errors, changeset} = register_person(%Person{}, params)

  """

  def register_person(params) do
    case Repo.get_by(Person, email: params["email"]) do
      nil  -> %Person{}
      person -> person
    end
    |> SubmissionManager.registration_changeset(params)
    |> Repo.insert_or_update
  end

  @doc """
  Create a new confirmation code for a person.
  If person is already confirmed return a tuple with an `:error` key.

  ## Examples

      iex> create_person_confirmation(person)
      {:ok,
        %Learnathon.SubmissionManager.
          ConfirmationCode{
            __meta__: #Ecto.Schema.Metadata<:loaded, "confirmation_codes">,
            body: "e1qg709v-f1vENET0ifxdTOH34dROU6gfK6dvwxaOf2DMXpOZwjC6jc1-6",
            email: nil, id: 44, inserted_at: ~N[2017-04-01 20:13:37.650429],
            person: #Ecto.Association.NotLoaded<association :person is not loaded>,
            person_id: 3, updated_at: ~N[2017-04-01 20:13:37.661758]}}

      iex> create_person_confirmation(confirmed_person)
      {:error, "You have already been confirmed."}
  """

  def create_person_confirmation(person) do
    if person.confirmed == true do
      {:error, "You have already been confirmed."}
    else
      Repo.transaction fn ->
        Ecto.
        build_assoc(person, 
          :confirmation_codes, 
          body: generate_hash())
        |> Repo.insert!
      end
    end
  end

  @doc """
  Generate a random string of 64 bytes.

  ## Example

    iex> generate_hash()
    "bf55XEwhP3YD3tMmYVzSfIsBuIVttjWXDKccMSOFCN1NdOuOFv48Nbkwn8oOKqQA"

  """

  def generate_hash do
    :crypto.
      strong_rand_bytes(64)
      |> Base.url_encode64
      |> binary_part(0, 64)
  end

  @doc """
  Get confirmation code by 64 byte string.
  This is the same string that is the ConfirmationCode's :body

  ## Example
  
      iex> get_confirmation_code(generated_hash)
      {:ok, %Learnathon.SubmissionManager.
        ConfirmationCode{__meta__: #Ecto.Schema.Metadata<:loaded, "confirmation_codes">,
      body: "-VloupjQLGQu_45NVJmYT91NjSGtV836zZTQEseZE7X20iK1hmHDOIncCqRyTQ7A",
      email: nil, id: 1, inserted_at: ~N[2017-03-29 16:56:12.603846],
      person: #Ecto.Association.NotLoaded<association :person is not loaded>,
      person_id: 1, updated_at: ~N[2017-03-29 16:56:12.616893]}}
  """

  def get_confirmation_code(cc) do
    case Repo.get_by(ConfirmationCode, body: cc) do
      nil -> {:error, "Could not find the confirmation code."}
      confirmation_code -> {:ok, confirmation_code}
    end
  end

  @doc """
  Delete all confirmation codes associated with a person.
  Return person without any confirmation codes

  ## Example

      iex> delete_all_confirmation_codes_for_person(person)
      {:ok, person}

  """
  def delete_all_confirmation_codes_for_person(person) do
    codes = person.confirmation_codes
    delete_all_confirmation_codes_for_person(person.id, codes, length(codes))
  end

  def delete_all_confirmation_codes_for_person(person_id, _, n) when n < 1 do
    get_person(person_id)
  end

  def delete_all_confirmation_codes_for_person(person_id, codes, _) do
    [confirmation_code | codes] = codes
    Repo.delete!(confirmation_code)
    delete_all_confirmation_codes_for_person(person_id, codes, length(codes))
  end

  @doc """
  Update a persons' confirmed attribute to true  `confirmed: true` using a 
  confirmation code and delete all existing confirmation codes associated with 
  person.

  ## Example

      iex> confirm_person(confirmation_code)
      {:ok, %Person

  """

  def confirm_person(confirmation_code) do
    SubmissionManager.get_person(confirmation_code.person_id)
    |> Repo.preload(:confirmation_codes)
    |> delete_all_confirmation_codes_for_person
    |> update_person(%{confirmed: true})
  end

  @doc """
  Return a changeset for a Person.
  This Changeset will validate a few things.
  - name and email are required
  - email must be unique
  - validates the format of an email

  ## Example
  
  iex> person_changeset(%Person{}, %{name: "sam", email: "sam@gmail.com"})
   #Ecto.Changeset<action: nil, changes: %{email: "sam@gmail.com", name: "sam"},
    errors: [], data: #Learnathon.SubmissionManager.Person<>, valid?: true>

  iex> person_changeset(%Person{}, %{})
  #Ecto.Changeset<action: nil, changes: %{},
    errors: [name: {"can't be blank", [validation: :required]},
    email: {"can't be blank", [validation: :required]}],
    data: #Learnathon.SubmissionManager.Person<>, valid?: false>

  """

  def person_changeset(%Person{} = person, params \\ %{}) do
    person
    |> cast(params, person_permitted_attributes())
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> validate_format(:email, email_format_regex())
  end

  @doc """
  Return a confirmation code changeset.
  This Changeset will validate a few things.
  - a body is required (this is a generated hash)
  - must be associated with a person

    ## Example

    iex> cs = SubmissionManager.confirmation_changeset(%ConfirmationCode{},
              %{body: SubmissionManager.generate_hash()})
    true

    iex> cs = confirmation_changeset(%ConfirmationCode{}, %{body: "123"})
    iex> cs.valid?
    false

  """

  def confirmation_changeset(%ConfirmationCode{} = confirmation, params \\ %{}) do
    confirmation
    |> cast(params, [:email, :body, :person_id])
    |> validate_length(:body, min: 64, max: 64)
    |> put_assoc(:person, required: true)
    |> validate_required([:body])
  end

  @doc """
  Return a registration changeset for a Person
  This changeset will validate a password
  - :password must be a min of 6 and max of 100 chars
  - if the changeset is valid it will return a changeset
    with a :password_hash

    iex> person = %Person{name: "Ben", email: "dude@gmail.com"}
    iex> changeset = registration_changeset(person, %{password: "123456"})
    iex> changeset.valid?
    true

    iex> changeset = registration_changeset(person, %{password: "1"})
    iex> changeset.valid?
    false

  """

  def registration_changeset(model, params) do
    model
    |> person_changeset(params)
    |> cast(params, ~w(password))
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ -> changeset
    end
  end

  def last_created_confirmation_code(person) do
    case length(person.confirmation_codes) do
      0 -> create_person_confirmation(person)
      _ -> List.last(person.confirmation_codes)
    end
    List.last(person.confirmation_codes)
  end

  defp person_permitted_attributes do
    [:name, :email, :workshop_idea, :time_needed, :company, :contribution, 
    :donation, :swag, :prizes, :confirmed, :username]
  end

  defp email_format_regex do
    ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  end
end
