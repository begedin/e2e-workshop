defmodule E2EWeb.SessionController do
  use E2EWeb, :controller

  alias E2E.Accounts

  action_fallback(E2EWeb.FallbackController)

  @spec new(Plug.Conn.t(), map) :: Plug.Conn.t()
  def new(conn, %{}) do
    conn
    |> assign(:changeset, Accounts.new_user())
    |> render(:new)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"user" => user_params} = params) do
    case Accounts.login(user_params) do
      {:ok, token} ->
        conn
        |> put_session(:token, token)
        |> redirect(to: Routes.todo_path(conn, :index))

      {:error, :login_invalid} ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Invalid credentials")
        |> new(params)
    end
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{}) do
    conn
    |> clear_session()
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
