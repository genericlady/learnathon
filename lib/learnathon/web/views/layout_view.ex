defmodule Learnathon.Web.LayoutView do
  use Learnathon.Web, :view

  def show_flash(conn) do
    Phoenix.Controller.get_flash(conn) |> flash_msg
  end

  def flash_msg(%{"info" => msg}) do
    ~E"<div class='alert alert-info'><%= msg %></div>"
  end

  def flash_msg(%{"error" => msg}) do
    ~E"<div class='alert alert-danger'><%= msg %></div>"
  end

  def flash_msg(_) do
    nil
  end
end
