defmodule Learnathon.Factory do
  use ExMachina.Ecto, repo: Learnathon.Repo
  alias Learnathon.{
                     SubmissionManager,
                     SubmissionManager.Person,
                     SubmissionManager.ConfirmationCode }

  def person_factory do
    %Person{
      name: "Johnny Appleseed",
      email: sequence(:email, &"email-#{&1}@example.com"),
      confirmation_codes: [build(:confirmation_code)],
    }
  end

  def person_no_code_factory do
    %Person{
      name: "Johnny Appleseed",
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end

  def confirmation_code_factory do
    %ConfirmationCode{
      body: SubmissionManager.generate_hash(),
      inserted_at: time_now(),
    }
  end

  def expired_confirmation_code_factory do
    %ConfirmationCode{
      body: SubmissionManager.generate_hash(),
      inserted_at: sixteen_minutes_from_now(),
    }
  end

  defp sixteen_minutes_from_now do
    NaiveDateTime.add(time_now(), -(60 * 16), :second)
  end

  defp time_now do
    DateTime.utc_now |> DateTime.to_naive
  end

end

