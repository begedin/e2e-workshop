defmodule TodoList.Factory do
  @moduledoc false
  # with Ecto
  use ExMachina.Ecto, repo: TodoList.Repo

  def user_factory do
    %TodoList.Accounts.User{
      name: sequence(:name, &"user-#{&1}"),
      password: sequence(:password, &"password-#{&1}")
    }
  end

  def todo_factory do
    %TodoList.Todos.Todo{
      title: sequence(:title, &"To Do #{&1}"),
      user: build(:user)
    }
  end
end
