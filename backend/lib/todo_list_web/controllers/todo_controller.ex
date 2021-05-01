defmodule TodoListWeb.TodoController do
  @moduledoc """
  Serves JSON endpoints related to todos
  """
  use TodoListWeb, :controller

  alias TodoList.{Accounts, Todos}

  action_fallback(TodoListWeb.FallbackController)

  plug(:authentication)

  defp authentication(conn, []) do
    with "Bearer " <> token <- conn |> Plug.Conn.get_req_header("authorization") |> List.first(),
         {:ok, %{id: id}} <- Accounts.verify_token(token),
         {:ok, user} <- Accounts.get_user(id) do
      assign(conn, :user, user)
    else
      _ ->
        conn
        |> put_status(401)
        |> put_view(TodoListWeb.ErrorView)
        |> render(:unauthenticated)
        |> halt()
    end
  end

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(%Plug.Conn{} = conn, %{} = _params) do
    todos = Todos.list_todos(conn.assigns.user)
    render(conn, :index, todos: todos)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(%Plug.Conn{} = conn, %{"todo" => todo_params}) do
    with {:ok, todo} <- Todos.create_todo(conn.assigns.user, todo_params) do
      conn |> put_status(201) |> render(:show, todo: todo)
    end
  end

  @spec delete(Plug.Conn.t(), map) :: any
  def delete(%Plug.Conn{} = conn, %{"id" => id}) do
    with {:ok, todo} <- Todos.get_todo(conn.assigns.user, id),
         {:ok, _todo} <- Todos.delete_todo(todo) do
      render(conn, "show.json", todo: todo)
    end
  end
end
