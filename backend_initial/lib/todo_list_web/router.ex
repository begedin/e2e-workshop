defmodule TodoListWeb.Router do
  use TodoListWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TodoListWeb, as: :api do
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
