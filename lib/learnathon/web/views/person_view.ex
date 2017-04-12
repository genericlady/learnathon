defmodule Learnathon.Web.PersonView do
  use Learnathon.Web, :view

  alias Learnathon.SubmissionManager.Person

  def first_name(%Person{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
