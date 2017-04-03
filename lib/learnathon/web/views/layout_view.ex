defmodule Learnathon.Web.LayoutView do
  use Learnathon.Web, :view

  def show_flash(conn) do
    Phoenix.Controller.get_flash(conn) |> flash_msg
  end

  def flash_msg(%{"info" => msg}) do
    ~E"<div class='alert alert-info-text text-center'><%= msg %></div>"
  end

  def flash_msg(%{"error" => msg}) do
    ~E"<div class='alert alert-danger-text text-center'><%= msg %></div>"
  end

  def flash_msg(%{"errors" => errors}) do
    Enum.map(errors, fn({k, v}) -> 
      {msg, _} = v
      ~E"<ul class='alert alert-danger-text text-center p-0 m-0'>
           <%= k %> <%= msg %>
         </ul>"
    end)
  end

  def flash_msg(_) do
    nil
  end
end
