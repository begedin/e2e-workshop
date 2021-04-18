defmodule E2E.Repo do
  use Ecto.Repo,
    otp_app: :e2e,
    adapter: Ecto.Adapters.Postgres
end
