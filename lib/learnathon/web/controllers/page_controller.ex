defmodule Learnathon.Web.PageController do
  use Learnathon.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def submission(conn, %{"workshop_submission" => workshop_submission}) do
    render conn, "thank_you.html", workshop_submission: workshop_submission
  end
end
