{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:wallaby)

Application.put_env(:wallaby, :base_url, E2EWeb.Endpoint.url())

ExUnit.configure(exclude: [:acceptance])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(E2E.Repo, :manual)
