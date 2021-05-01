use Mix.Config

config :todo_list, env: :test

config :phoenix, :plug_init_mode, :runtime

config :todo_list, TodoListWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  server: false

# Configure your database
config :todo_list, TodoList.Repo,
  username: "postgres",
  password: "postgres",
  database: "e2e_test",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn
