defmodule Learnathon.PersonControllerTest do
  use Learnathon.Web.ConnCase, async: true
  import Learnathon.Factory

  test "index/2 responds with all People." do
    people = [ insert(:person), 
               insert(:person, %{name: "Phil", email: "phil@gmail.com"}) ]
        
    response = get build_conn(), person_path(build_conn(), :index)

    for person <- people do
      assert html_response(response, 200) =~ person.name
    end
  end

  describe "show/2" do
    test "Responds with a newly created person if the person is found" do
      person = insert(:person)

      response = get build_conn(), person_path(build_conn(), :show, person.id)

      assert html_response(response, 200) =~ person.name
    end

    test "Responds with a message indicating person not found" do
      response = get build_conn(), person_path(build_conn(), :show, 99)

      assert html_response(response, 404) =~ "not found"
    end
  end

  test "new/2 responds with a form for a new person" do
    response = get build_conn(), person_path(build_conn(), :new)

    assert html_response(response, 200) =~ "New Person"
  end

  test "create/2 creates a person and redirects to their show page." do
    params = %{name: "sam", email: "zilly@gmail.com"}
    response = post build_conn(), person_path(build_conn(), :create, %{person_params: params})

    assert redirected_to(response) == person_path(response, :index)
  end

  test "create/2 redirects back to new person page when there are errors." do
    params = %{email: "sam"}
    response = post build_conn(), person_path(build_conn(), 
                                  :create, %{person_params: params})

    assert redirected_to(response) == page_path(response, :index)
  end
end
