use Mix.Config

config :phoenix, :plug_init_mode, :runtime

config :e2e, E2EWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  server: System.get_env("E2E") |> Kernel.is_nil() |> Kernel.not()

# Configure your database
config :e2e, E2E.Repo,
  username: "postgres",
  password: "postgres",
  database: "e2e_test",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :e2e, sql_sandbox: System.get_env("SANDBOX") |> Kernel.is_nil() |> Kernel.not()

# Print only warnings and errors during test
config :logger, level: :warn

config :wallaby,
  chromedriver: [
    headless: System.get_env("HEADLESS") |> Kernel.is_nil() |> Kernel.not(),
    capabilities: %{
      javascriptEnabled: true,
      chromeOptions: %{
        args: [
          "--no-sandbox",
          "window-size=1280,720",
          "--disable-gpu",
          "--headless",
          "--fullscreen",
          "--user-agent=Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"
        ]
      }
    }
  ],
  otp_app: :e2e
