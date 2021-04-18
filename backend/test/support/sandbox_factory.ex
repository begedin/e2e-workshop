defmodule E2E.SandboxFactory do
  @moduledoc false

  use ExMachina.Ecto, repo: E2E.Repo

  alias E2E.{Accounts, Repo}
  alias E2E.Factory, as: CoreFactory

  def user_factory(attrs) do
    CoreFactory.build(:user, attrs)
  end

  def todo_factory(attrs) do
    attrs
    |> assoc_by_id(:user, Accounts.User)
    |> do_build(:todo)
  end

  defp assoc_by_id(attrs, assoc_key, module) do
    with %{} = assoc <- attrs[assoc_key],
         id when not is_nil(id) <- assoc[:id] do
      attrs |> Map.put(assoc_key, Repo.get(module, id))
    else
      nil -> attrs
    end
  end

  defp do_build(attrs, schema) do
    CoreFactory.build(schema, attrs)
  end
end
