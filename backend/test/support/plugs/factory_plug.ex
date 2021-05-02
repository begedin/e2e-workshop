defmodule TodoList.FactoryPlug do
  @moduledoc """
  Expose endpoints which provide effectively direct access to ex_machina
  factories.

  This allows us to easily setup test data for our e2e tests.

  This module is not concerned with the ecto sandbox being checked out.



  POST /api/factory

  Can be used to create database records, similar to how it's done in unit
  tests.

  Results will be rendered as basic json, with foreign key ids exposed, so they
  can be used to create additional data.
  """
  @behaviour Plug

  alias Plug.Conn
  alias TodoList.SandboxFactory

  def init(_) do
    Application.start(:ex_machina)
  end

  def call(%Conn{method: "POST", request_path: "/factory"} = conn, _) do
    with {:ok, schema} <- Map.fetch(conn.body_params, "schema"),
         {:ok, attrs} <- Map.fetch(conn.body_params, "attributes") do
      db_schema = String.to_atom(schema)
      db_attrs = atomize(attrs)

      rendered =
        db_schema
        |> create(db_attrs, Map.get(conn.body_params, "count"))
        |> Jason.encode!()

      Conn.send_resp(conn, 200, rendered) |> Conn.halt()
    else
      _ -> Conn.send_resp(conn, 401, "schema or attributes missing") |> Conn.halt()
    end
  end

  def call(%Conn{} = conn, _), do: conn

  @spec create(atom, list(map) | map, nil | integer) :: struct | list(struct)
  def create(schema, attrs, nil) when is_list(attrs) do
    Enum.map(attrs, &create(schema, &1, nil))
  end

  def create(schema, %{} = attrs, nil) do
    SandboxFactory.insert(schema, attrs)
  end

  def create(schema, %{} = attrs, count) do
    SandboxFactory.insert_list(count, schema, attrs)
  end

  @spec atomize(any) :: any
  defp atomize(%{} = attrs) do
    attrs
    |> Enum.map(fn {k, v} -> {String.to_atom(k), atomize(v)} end)
    |> Map.new()
  end

  defp atomize(attrs) when is_list(attrs) do
    Enum.map(attrs, &atomize/1)
  end

  defp atomize(v), do: v
end
