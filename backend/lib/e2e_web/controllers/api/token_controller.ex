defmodule E2EWeb.API.TokenController do
  use E2EWeb, :controller

  alias E2E.Accounts

  action_fallback(E2EWeb.FallbackController)

  def login(conn, %{"login" => params}) do
    with {:ok, token} <- Accounts.login(params) do
      json(conn, %{data: token})
    end
  end
end
