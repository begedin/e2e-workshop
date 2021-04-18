defmodule E2EWeb.API.TokenControllerTest do
  use E2EWeb.ConnCase

  @valid_attrs %{
    "name" => "james",
    "password" => "password"
  }

  @invalid_attrs %{
    "name" => "james",
    "password" => "wrongpassword"
  }

  setup %{conn: conn} do
    insert(:user, name: "james", password: "password")
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "login" do
    test "responds with token", %{conn: conn} do
      path = Routes.api_token_path(conn, :login)
      assert response = conn |> post(path, login: @valid_attrs) |> json_response(200)
      assert response["data"]
    end

    test "responds with 401 if invalid params", %{conn: conn} do
      path = Routes.api_token_path(conn, :login)
      assert conn |> post(path, login: @invalid_attrs) |> json_response(401)
    end
  end
end
