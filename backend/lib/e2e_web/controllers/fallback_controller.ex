defmodule E2EWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use E2EWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(E2EWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(E2EWeb.ChangesetView)
    |> render("error.json", %{changeset: changeset})
  end

  def call(conn, {:error, :login_invalid}) do
    conn
    |> put_status(401)
    |> put_view(E2EWeb.ErrorView)
    |> render("error.json", %{reason: "login_invalid"})
  end
end
