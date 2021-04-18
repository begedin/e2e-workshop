defmodule E2E.Acceptance.LoginTest do
  @moduledoc false

  use E2E.E2ECase
  import E2E.Factory

  @moduletag :acceptance

  feature "signs up with correct credentials", %{session: session} do
    user = insert(:user)

    session
    |> visit("/")
    |> fill_in(Query.css("#user_name"), with: user.name)
    |> fill_in(Query.css("#user_password"), with: user.password)
    |> click(Query.button("Login"))
    |> assert_has(Query.button("Log Out"))

    assert current_path(session) == "/"
  end

  feature "shows error if incorrect credentials", %{session: session} do
    user = insert(:user)

    session
    |> visit("/")
    |> fill_in(Query.css("#user_name"), with: user.name)
    |> fill_in(Query.css("#user_password"), with: "wrongpassword")
    |> click(Query.button("Login"))
    |> assert_has(Query.link("Register"))
    |> assert_has(Query.link("Login"))
    |> assert_has(Query.css(".alert-danger"))
    |> refute_has(Query.button("Log Out"))

    assert current_path(session) == "/login"
  end
end
