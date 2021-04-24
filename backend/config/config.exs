# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :e2e,
  namespace: E2E,
  ecto_repos: [E2E.Repo]

# Configures the endpoint
config :e2e, E2EWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xJpwfY1gWDnVYc3qbR1wHe8ZKLcZR2Tx6z+TwsDHJHWeGqS+HPKp+DsADx3JuvhA",
  render_errors: [view: E2EWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: E2E.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
