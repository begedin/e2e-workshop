defmodule E2E.TodosTest do
  use E2E.DataCase

  alias E2E.Todos

  describe "todos" do
    @valid_attrs %{title: "some title"}
    @invalid_attrs %{title: nil}

    test "list_todos/1 returns all todos for user" do
      user = insert(:user)
      [todo_1, todo_2] = insert_pair(:todo, user: user)
      todo_3 = insert(:todo)
      assert [_, _] = todos = Todos.list_todos(user)
      assert todo_1.id in Enum.map(todos, & &1.id)
      assert todo_2.id in Enum.map(todos, & &1.id)
      refute todo_3.id in Enum.map(todos, & &1.id)
    end

    test "get_todo/2 returns the todo with given id for user" do
      %{user: user} = todo = insert(:todo)
      assert {:ok, _todo} = Todos.get_todo(user, todo.id)
    end

    test "get_todo/2 returns error if given id does not belong to user" do
      user = insert(:user)
      todo = insert(:todo)
      assert {:error, :not_found} = Todos.get_todo(user, todo.id)
    end

    test "get_todo/2 returns error if incorrect id" do
      user = insert(:user)
      assert {:error, :not_found} = Todos.get_todo(user, -1)
    end

    test "create_todo/2 with valid data creates a todo" do
      user = insert(:user)
      assert {:ok, todo} = Todos.create_todo(user, @valid_attrs)
      assert todo.title === "some title"
      assert todo.user_id === user.id
    end

    test "create_todo/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %{valid?: false}} = Todos.create_todo(user, @invalid_attrs)
    end

    test "delete_todo/1 deletes todo" do
      todo = insert(:todo)
      assert {:ok, _todo} = Todos.delete_todo(todo)
      refute Repo.get(Todos.Todo, todo.id)
    end

    test "new_todo/1 returns a todo changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Todos.new_todo(user)
    end
  end
end
