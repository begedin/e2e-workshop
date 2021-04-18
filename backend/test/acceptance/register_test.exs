defmodule E2E.Acceptance.RegisterTest do
  @moduledoc false

  use E2E.E2ECase

  alias E2E.{Accounts, Repo}

  @moduletag :acceptance

  feature "registers account", %{session: session} do
    session
    |> visit("/")
    |> click(Query.link("Register"))
    |> fill_in(Query.css("#user_name"), with: "Mike")
    |> fill_in(Query.css("#user_password"), with: "password")
    |> click(Query.button("Register"))
    |> assert_has(Query.button("Log Out"))

    assert current_path(session) == "/"
    assert Repo.get_by(Accounts.User, name: "Mike", password: "password")
  end
end
