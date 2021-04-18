defmodule E2E.E2EPlug do
  @moduledoc """
  Exposes endpoints required for effective writing of E2E tests

  GET /api/sent_emails renders a JSON of sent emails
  POST /api/factory can be used to create database records, similar to how it's done in unit tests

  Is effectively a rudimentary interface to `:ex_machina`.
  """
  @behaviour Plug

  alias E2E.SandboxFactory
  alias Plug.Conn

  def init(_) do
    enabled = Application.get_env(:e2e, :sql_sandbox, false)

    if enabled do
      Application.start(:ex_machina)
    end

    [enabled: enabled]
  end

  def call(%Conn{} = conn, enabled: false), do: conn

  def call(%Conn{method: "POST", request_path: "/api/factory"} = conn, enabled: true) do
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

  def call(%Conn{} = conn, enabled: true), do: conn

  @spec create(atom, list(map) | map, nil | integer) :: struct | list(struct)
  def create(schema, attrs, nil) when is_list(attrs) do
    Enum.map(attrs, &create(schema, &1, nil))
  end

  def create(schema, %{} = attrs, nil), do: SandboxFactory.insert(schema, attrs)
  def create(schema, %{} = attrs, count), do: SandboxFactory.insert_list(count, schema, attrs)

  @spec atomize(any) :: any
  defp atomize(%{} = attrs),
    do: Enum.map(attrs, fn {k, v} -> {String.to_atom(k), atomize(v)} end) |> Enum.into(%{})

  defp atomize(attrs) when is_list(attrs), do: Enum.map(attrs, &atomize/1)
  defp atomize(v), do: v
end
