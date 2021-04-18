defmodule E2E.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, only: [order_by: 2, where: 2]

  alias E2E.{Accounts, Repo, Todos}
  alias Ecto.Changeset

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todos.Todo{}, ...]

  """
  def list_todos(%Accounts.User{} = user) do
    Todos.Todo |> where(user_id: ^user.id) |> order_by(asc: :id) |> Repo.all()
  end

  @doc """
  Gets a single todo by user and id

  Returns {:error, :not_found} if todo non-existant
  """
  def get_todo(%Accounts.User{} = user, id) do
    case Repo.get_by(Todos.Todo, id: id, user_id: user.id) do
      nil -> {:error, :not_found}
      todo -> {:ok, todo}
    end
  end

  @doc """
  Creates a todo for a user
  """
  @spec create_todo(Accounts.User.t(), map) :: any
  def create_todo(%Accounts.User{} = user, %{} = attrs) do
    %Todos.Todo{}
    |> Todos.Todo.changeset(attrs)
    |> Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todos.Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todos.Todo{} = todo) do
    Repo.delete(todo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for for creating a new todo
  """
  @spec new_todo(Accounts.User.t()) :: Changeset.t()
  def new_todo(%Accounts.User{} = user) do
    %Todos.Todo{}
    |> Todos.Todo.changeset(%{})
    |> Changeset.put_assoc(:user, user)
  end
end
