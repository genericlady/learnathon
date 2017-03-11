defmodule Learnathon.Web.SubmissionController do
  use Learnathon.Web, :controller

  def show(conn, %{"workshop_submission" => workshop_submission}) do
    render conn, "show.html", workshop_submission: workshop_submission
  end
end
