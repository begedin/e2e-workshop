defmodule E2E.SandboxEnforcerPlug do
  @moduledoc """
  Adds support for sandbox mode in the e2e environment.

  In sandbox mode, the following is in effect

  - the `GET /api/ping` endpoint is enabled, which is used by Jenkins to check if API is up
  - the `POST /api/sandbox` and `DELETE /api/sandbox` endpoints are enabled, to checkout and checkin an Ecto sandbox connection
  - all other endpoints return an error if a `sandbox` header with a valid sandbox id is not present
  """
  @behaviour Plug

  alias Plug.Conn

  require Logger

  def init(_) do
    [enabled: Application.get_env(:e2e, :sql_sandbox, false)]
  end

  def call(conn, enabled: false), do: conn

  def call(conn, enabled: true) do
    sandbox_id = Conn.get_req_header(conn, "sandbox") |> List.wrap() |> List.first()

    case {conn.method, conn.request_path} do
      {"POST", "/api/sandbox"} -> log_sandbox_checkout(conn)
      {"DELETE", "/api/sandbox"} -> resolve_sandbox_checkin(conn, sandbox_id)
      {_method, "/socket" <> _path} -> conn
      {method, path} -> ensure_sandbox_id(conn, method, path, sandbox_id)
    end
  end

  defp log_sandbox_checkout(conn) do
    Conn.register_before_send(conn, fn before_send_conn ->
      Logger.warn("Checked out sandbox session #{before_send_conn.resp_body}")
      before_send_conn
    end)
  end

  defp resolve_sandbox_checkin(conn, nil) do
    message = "Attempting to check in a sandbox session, but no sandbox in headers, sent 400"
    Logger.error(message)

    conn |> Conn.send_resp(400, "Provide a valid sandbox header")
  end

  defp resolve_sandbox_checkin(conn, sandbox_id) do
    Logger.warn("Checking in sandbox session #{sandbox_id}")
    conn
  end

  defp ensure_sandbox_id(conn, method, path, nil) do
    message = "Attempting to #{method} #{path}, but no sandbox in headers, sent 400"
    Logger.error(message)
    conn |> Conn.send_resp(400, "Provide a valid sandbox header") |> Conn.halt()
  end

  defp ensure_sandbox_id(conn, method, path, sandbox_id) do
    Logger.warn("#{method} #{path}, sandbox: #{sandbox_id || "none"}")
    conn
  end
end
