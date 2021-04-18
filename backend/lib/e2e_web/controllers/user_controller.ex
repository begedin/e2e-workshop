defmodule E2EWeb.UserController do
  use E2EWeb, :controller

  alias E2E.Accounts

  action_fallback E2EWeb.FallbackController

  @spec new(Plug.Conn.t(), map) :: Plug.Conn.t()
  def new(%Plug.Conn{} = conn, %{}) do
    conn |> render(:new, changeset: Accounts.new_user())
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(%Plug.Conn{} = conn, %{"user" => user_params}) do
    with {:ok, _user} <- Accounts.create_user(user_params),
         {:ok, token} <- Accounts.login(user_params) do
      conn
      |> put_session(:token, token)
      |> redirect(to: Routes.todo_path(conn, :index))
    end
  end
end
