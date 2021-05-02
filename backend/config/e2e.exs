# Configuration file for the TodoList testing environment
# See additional details in root/README.md as well as root/backend/README.md

use Mix.Config

config :todo_list, env: :e2e

# Reduce bcrypt algorithm complexity in test to speed it up

# The e2e environment endpoint is mostly like the dev environment endpoint
# It supports code reloading, for faster development and the ability to use
# the e2e suite as a constantly running tool.
config :todo_list, TodoListWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# The e2e environment repo is more like the test repo. It uses the sandbox
# pool to connect to the db.
config :todo_list, TodoList.Repo,
  username: "postgres",
  password: "postgres",
  database: "todo_list_e2e",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
