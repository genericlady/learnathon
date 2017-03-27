defmodule Learnathon.Web.SubmissionControllerTest do
  use Learnathon.Web.ConnCase

  import Learnathon.Factory

  test "updates person and redirects", %{conn: conn} do
    person = insert(:person)
    confirmation_code = insert(:confirmation_code, %{email: person.email})

    conn = put(conn, submission_path(conn, :update), 
               confirmation_code: confirmation_code)

    assert redirected_to(conn) == page_path(conn, :index)
  end
end
