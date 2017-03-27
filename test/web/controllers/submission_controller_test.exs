defmodule Learnathon.Web.SubmissionControllerTest do
  use Learnathon.Web.ConnCase

  alias Learnathon.SubmissionManager.Person
  import Learnathon.Factory

  test "updates person and redirects", %{conn: conn} do
    person = insert(:person)
    confirmation_code = Person.last_created_confirmation_code(person)

    conn = put(conn, submission_path(conn, :update), 
               confirmation_code: confirmation_code.body)

    assert redirected_to(conn) == page_path(conn, :index)
  end
end
