defmodule E2EWeb.API.TodoControllerTest do
  use E2EWeb.ConnCase

  alias E2E.{Accounts, Repo, Todos}

  @create_attrs %{title: "some title"}
  @invalid_attrs %{title: nil}

  defp accept_json(%{conn: conn}) do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup :accept_json

  defp authenticate(conn, user) do
    {:ok, token} = Accounts.login(%{"name" => user.name, "password" => user.password})
    conn |> put_req_header("authorization", "Bearer #{token}")
  end

  describe "index" do
    test "lists all todos", %{conn: conn} do
      user = insert(:user)
      path = Routes.api_todo_path(conn, :index)
      assert json = conn |> authenticate(user) |> get(path) |> json_response(200)
      assert json["data"] == []
    end
  end

  describe "create todo" do
    test "creates and renders todo when data is valid", %{conn: conn} do
      user = insert(:user)
      path = Routes.api_todo_path(conn, :create)

      assert json =
               conn
               |> authenticate(user)
               |> post(path, todo: @create_attrs)
               |> json_response(201)

      assert %{"id" => id, "title" => "some title"} = json["data"]
      assert Repo.get!(Todos.Todo, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = insert(:user)
      path = Routes.api_todo_path(conn, :create)

      assert json =
               conn
               |> authenticate(user)
               |> post(path, todo: @invalid_attrs)
               |> json_response(422)

      assert json["errors"]["title"]
    end
  end

  describe "delete todo" do
    test "deletes chosen todo", %{conn: conn} do
      user = insert(:user)
      todo = insert(:todo, user: user)
      path = Routes.api_todo_path(conn, :delete, todo)

      assert json = conn |> authenticate(user) |> delete(path) |> json_response(200)

      assert json["data"]["id"] === todo.id
      assert json["data"]["title"] === todo.title

      refute Repo.get(Todos.Todo, todo.id)
    end

    test "renders 404 if todo missing", %{conn: conn} do
      user = insert(:user)
      path = Routes.api_todo_path(conn, :delete, -1)

      assert conn |> authenticate(user) |> delete(path) |> json_response(404)
    end

    test "renders 404 if todo does not belong to user", %{conn: conn} do
      user = insert(:user)
      todo = insert(:todo)
      path = Routes.api_todo_path(conn, :delete, todo)

      assert conn |> authenticate(user) |> delete(path) |> json_response(404)
    end
  end
end
