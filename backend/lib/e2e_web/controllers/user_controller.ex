defmodule E2EWeb.UserController do
  use E2EWeb, :controller

  alias E2E.Accounts

  action_fallback(E2EWeb.FallbackController)

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} = Accounts.get_user(id) do
      render(conn, "show.json", user: user)
    end
  end
end
