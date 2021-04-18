defmodule E2EWeb.API.UserControllerTest do
  use E2EWeb.ConnCase

  alias E2E.{Accounts, Repo}

  @create_attrs %{
    "name" => "james",
    "password" => "password1"
  }

  @invalid_attrs %{
    "name" => nil,
    "password" => nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      path = Routes.api_user_path(conn, :create)
      assert json = conn |> post(path, user: @create_attrs) |> json_response(201)
      assert %{"id" => id} = json["data"]
      assert Repo.get(Accounts.User, id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      path = Routes.api_user_path(conn, :create)
      assert json = conn |> post(path, user: @invalid_attrs) |> json_response(422)
      assert json["errors"]["name"]
    end
  end
end
