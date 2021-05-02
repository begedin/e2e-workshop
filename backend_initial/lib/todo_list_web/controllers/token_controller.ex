defmodule TodoListWeb.TokenController do
  use TodoListWeb, :controller

  alias TodoList.Accounts

  action_fallback(TodoListWeb.FallbackController)

  def login(conn, %{"login" => params}) do
    with {:ok, token} <- Accounts.login(params) do
      json(conn, %{data: token})
    end
  end
end
