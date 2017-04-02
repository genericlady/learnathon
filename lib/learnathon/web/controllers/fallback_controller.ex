defmodule Learnathon.Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use Learnathon.Web, :controller

  def call(conn, {:errors, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_flash(:errors, changeset.errors)
    |> redirect(to: page_path(conn, :index))
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(Learnathon.Web.ErrorView, :"404")
  end

  def call(conn, {:error, message}) do
    conn
    |> put_flash(:error, message)
    |> redirect(to: page_path(conn, :index))
  end

end

