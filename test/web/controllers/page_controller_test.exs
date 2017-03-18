defmodule Learnathon.Web.PageControllerTest do
  use Learnathon.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "NYC Learnathon Summer 2017"
  end
end
