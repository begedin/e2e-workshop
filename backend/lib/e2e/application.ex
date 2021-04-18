defmodule E2E.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      E2E.Repo,
      {Phoenix.PubSub, [name: E2E.PubSub, adapter: Phoenix.PubSub.PG2]},
      # Start the endpoint when the application starts
      E2EWeb.Endpoint
      # Starts a worker by calling: E2E.Worker.start_link(arg)
      # {E2E.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: E2E.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    E2EWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
