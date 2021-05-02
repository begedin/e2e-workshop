defmodule TodoList.SandboxFactory do
  @moduledoc """
  Special factory for use in E2E/Acceptance testing

  The sandbox /factory endpoint uses this factory to create records.

  Key difference is the ability to specify associations via a map, containing an
  id.

  By default, ex_machina factories will skip creating an association if it's
  specified as a struct, already inserted and with an id.

  For example,

  ```
  insert(:todo, user: %User{id: 1})
  ```

  Will create a new todo, but will reuse the user, rather than try creating it.

  However, when the user is specified as a map, no such attempt will be made.
  For example,

  ```
  insert(:todo, user: %{id: 1})
  ```

  will fail with an error, due to attempting to insert a user with id 1, which
  already exists in the db.


  This special factory module checks if the specified association has an id and
  if so, loads the associated record, before inserting the main record, so the
  previous example with using a map for specifying a user will just work.
  """

  use ExMachina.Ecto, repo: TodoList.Repo

  alias TodoList.{Accounts, Repo}
  alias TodoList.Factory, as: BaseFactory

  def user_factory(attrs) do
    BaseFactory.build(:user, attrs)
  end

  def todo_factory(attrs) do
    attrs
    |> assoc_by_id(:user, Accounts.User)
    |> do_build(:todo)
  end

  # If attrs has an association key, for example, attrs for todo have a `:user`,
  # and that association as a key `:id`, then load the associated record using
  # specified module and replace the association key with the loaded record.
  #
  # Otherwise, do nothing
  #
  # For example:
  #
  # ```
  # assoc_by_id([title: "Foo", user: %{id: 1}])
  #
  # > [title: "Foo", user: %TodoList.Accounts.User{id: 1}]
  # ```
  defp assoc_by_id(attrs, assoc_key, module) do
    with %{} = assoc <- attrs[assoc_key],
         id when not is_nil(id) <- assoc[:id] do
      attrs |> Map.put(assoc_key, Repo.get(module, id))
    else
      nil -> attrs
    end
  end

  defp do_build(attrs, schema) do
    BaseFactory.build(schema, attrs)
  end
end
