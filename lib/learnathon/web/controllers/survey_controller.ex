defmodule Learnathon.Web.SurveyController do
  use Learnathon.Web, :controller
  action_fallback Learnathon.Web.FallbackController

  def show(conn) do
    # case conn.request_path do

  end
end
