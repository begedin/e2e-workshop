defmodule E2EWeb.API.TodoView do
  @moduledoc """
  Renders JSON Todo endpoints
  """
  use E2EWeb, :view

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, __MODULE__, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, __MODULE__, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    Map.take(todo, [:id, :title])
  end
end
