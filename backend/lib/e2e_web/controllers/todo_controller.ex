defmodule E2EWeb.TodoController do
  @moduledoc """
  Serves HTML endpoints related to todos
  """
  use E2EWeb, :controller

  alias E2E.{Accounts, Todos}

  action_fallback(E2EWeb.FallbackController)

  plug :authentication

  defp authentication(conn, []) do
    with token when is_binary(token) <- get_session(conn, :token),
         {:ok, %{id: id}} <- Accounts.verify_token(token),
         user <- Accounts.get_user!(id) do
      assign(conn, :user, user)
    else
      _ -> conn |> redirect(to: Routes.session_path(conn, :new)) |> halt()
    end
  end

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(%Plug.Conn{} = conn, %{} = _params) do
    todos = Todos.list_todos(conn.assigns.user)
    changeset = Todos.new_todo(conn.assigns.user)
    render(conn, :index, changeset: changeset, todos: todos)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(%Plug.Conn{} = conn, %{"todo" => todo_params}) do
    with {:ok, _todo} <- Todos.create_todo(conn.assigns.user, todo_params) do
      redirect(conn, to: Routes.todo_path(conn, :index))
    end
  end

  @spec delete(Plug.Conn.t(), map) :: any
  def delete(%Plug.Conn{} = conn, %{"id" => id}) do
    with {:ok, todo} <- Todos.get_todo(conn.assigns.user, id),
         {:ok, _todo} <- Todos.delete_todo(todo) do
      redirect(conn, to: Routes.todo_path(conn, :index))
    end
  end
end
