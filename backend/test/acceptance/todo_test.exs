defmodule E2E.Acceptance.TodoTest do
  @moduledoc false

  use E2E.E2ECase
  import E2E.Factory
  alias E2E.{Repo, Todos}

  @moduletag :acceptance

  defp login(session, name, password) do
    session
    |> visit("/")
    |> fill_in(Query.css("#user_name"), with: name)
    |> fill_in(Query.css("#user_password"), with: password)
    |> click(Query.button("Login"))
    |> assert_has(Query.button("Log Out"))
  end

  feature "lists todos", %{session: session} do
    user = insert(:user)
    insert(:todo, user: user, title: "Write Homework")
    insert(:todo, user: user, title: "Buy Milk")

    session
    |> login(user.name, user.password)
    |> assert_has(Query.css(".todo", count: 1, text: "Write Homework"))
    |> assert_has(Query.css(".todo", count: 1, text: "Buy Milk"))
  end

  feature "creates todos", %{session: session} do
    user = insert(:user)

    session
    |> login(user.name, user.password)
    |> fill_in(Query.text_field("New todo"), with: "Write Essay")
    |> click(Query.button("Create"))
    |> assert_has(Query.css(".todo", count: 1, text: "Write Essay"))
  end

  feature "deletes todos", %{session: session} do
    user = insert(:user)
    insert(:todo, user: user, title: "Write Homework")

    session
    |> login(user.name, user.password)
    |> click(Query.button("Delete"))
    |> assert_has(Query.css("div", text: "You don't have any todos"))

    refute Repo.one(Todos.Todo)
  end
end
