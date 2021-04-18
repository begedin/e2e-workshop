defmodule E2E.Todos.Todo do
  @moduledoc "Maps a todo onto the database"
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :user_id]}
  schema "todos" do
    field(:title, :string)

    belongs_to(:user, E2E.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
