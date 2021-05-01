defmodule TodoListWeb.UserView do
  @moduledoc """
  Renders JSON user endpoints
  """
  use TodoListWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id}
  end
end
