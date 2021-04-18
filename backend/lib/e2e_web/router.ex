defmodule E2EWeb.Router do
  use E2EWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", E2EWeb do
    pipe_through(:browser)

    get("/", TodoController, :index)
    post("/todos", TodoController, :create)
    delete("/todos/:id", TodoController, :delete)

    get("/login", SessionController, :new)
    post("/login", SessionController, :create)
    delete("/login", SessionController, :delete)
    get("/register", UserController, :new)
    post("/register", UserController, :create)
  end

  scope "/api/", E2EWeb.API, as: :api do
    pipe_through(:api)

    post("/login", TokenController, :login)

    get("/users", UserController, :index)
    post("/users", UserController, :create)
    get("/users/:id", UserController, :show)
    put("/users/:id", UserController, :update)
    delete("/users/:id", UserController, :delete)

    get("/todos", TodoController, :index)
    post("/todos", TodoController, :create)
    delete("/todos/:id", TodoController, :delete)
  end
end
