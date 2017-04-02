defmodule Learnathon.Web.SubmissionControllerTest do
  use Learnathon.Web.ConnCase

  alias Learnathon.{Repo, 
                    SubmissionManager,
                    SubmissionManager.Person,}

  import Learnathon.Factory

  test "create action will either get or create a person", %{conn: conn} do
    submission = %{name: "sally", email: "yoyo@gmail.com"}
    conn = post(conn, submission_path(conn, :create), submission: submission)
    [person | _] = Repo.all Person

    assert person.name == "sally"
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "create action will create a confirmation code", %{conn: conn} do
    submission = %{name: "sally", email: "yoyo@gmail.com"}
    conn = post(conn, submission_path(conn, :create), submission: submission)
    [person | _] = Repo.all Person

    person = Repo.preload(person, :confirmation_codes)
    assert length(person.confirmation_codes) == 1
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "updates person and redirects", %{conn: conn} do
    person = insert(:person)
    confirmation_code = SubmissionManager.last_created_confirmation_code(person)

    conn = put(conn, submission_path(conn, :update), 
               confirmation_code: confirmation_code.body)

    assert redirected_to(conn) == page_path(conn, :index)
  end
end
