defmodule E2EWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :e2e

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_e2e_key",
    signing_salt: "5chpHyH3"
  ]

  socket("/socket", E2EWeb.UserSocket,
    websocket: true,
    longpoll: false
  )

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: :e2e,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(CORSPlug, headers: CORSPlug.defaults()[:headers] ++ ["Sandbox"])

  if Mix.env() === :test do
    plug(E2E.SandboxEnforcerPlug)

    plug(Phoenix.Ecto.SQL.Sandbox,
      at: "/api/sandbox",
      repo: E2E.Repo,
      timeout: 60_000,
      header: "sandbox"
    )
  end

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  if Mix.env() === :test do
    plug(E2E.E2EPlug)
  end

  plug(Plug.Session, @session_options)
  plug(E2EWeb.Router)
end
