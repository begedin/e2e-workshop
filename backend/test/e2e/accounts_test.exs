defmodule E2E.AccountsTest do
  use E2E.DataCase

  alias E2E.Accounts

  describe "users" do
    test "list_users/0 returns all users" do
      user = insert(:user)
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    @valid_attrs %{name: "some name", password: "some password"}

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %Accounts.User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "some name"
      assert user.password == "some password"
    end

    @invalid_attrs %{name: nil, password: nil}

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    @update_attrs %{name: "some updated name", password: "some updated password"}

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      assert {:ok, %Accounts.User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.name == "some updated name"
      assert user.password == "some updated password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %Accounts.User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "login/1 creates token on valid params" do
      user = insert(:user)
      assert {:ok, _token} = Accounts.login(%{"name" => user.name, "password" => user.password})
    end

    test "login/1 responds with error on invalid params" do
      assert {:error, :login_invalid} = Accounts.login(%{"name" => "foo", "password" => "bar"})
    end
  end
end
