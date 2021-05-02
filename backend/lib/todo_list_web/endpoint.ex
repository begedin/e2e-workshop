defmodule TodoListWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :todo_list

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_e2e_key",
    signing_salt: "5chpHyH3"
  ]

  socket("/socket", TodoListWeb.UserSocket,
    websocket: true,
    longpoll: false
  )

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: :todo_list,
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

  # We use a key in config, rather than just checking Mix.env, because
  # Mix.env will not be available, if we want to run this in release, for
  # example.
  is_e2e? = Application.get_env(:todo_list, :env) === :e2e

  # CorsPlug is generally needed when the backend is served from a different
  # endpoint to the frontend, but for e2e, we need to allow an extra header.
  cors_headers =
    if is_e2e? do
      CORSPlug.defaults()[:headers] ++ ["sandbox"]
    else
      CORSPlug.defaults()[:headers]
    end

  plug(CORSPlug, headers: cors_headers)

  if is_e2e? do
    # Prevents all api requests without a sandbox id in
    # headers from going through.,
    plug(TodoList.SandboxEnforcerPlug)

    # Exposes endpoints to checkout a sandbox, generating a sandbox id, as
    # well as to check that sandbox back in
    plug(Phoenix.Ecto.SQL.Sandbox,
      at: "/sandbox",
      repo: TodoList.Repo,
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

  if is_e2e? do
    # Exposes additional endpoints to easily create db records needed for
    # test setup.
    plug(TodoList.FactoryPlug)
  end

  plug(Plug.Session, @session_options)
  plug(TodoListWeb.Router)
end
