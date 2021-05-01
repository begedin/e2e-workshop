# e2e-workshop

Holds lesson notes and code needed to hold or participate in a workshop in which
the goal is to setup an E2E testing environment, in a scenario where the
frontend and backend are separate environments.
# Repository structure

## /backend

An elixir+phoenix backend which is a simple todo creation api

- tests can be run using `mix test`
- backend can be started using `mix phx.server`
- backend can be started for e2e testing using `MIX_ENV=e2e mix phx.server`

In a real-life scenario, this might not be part of the core repository and
instead can be cloned from a separate remote repository.

## /frontend

A vue3 + vue-router4 + vuex4 + vite frontend, directly integrated
with the backend.

- runs in dev mode using `npm run dev`

In a real-life scenario, this might not be part of the core repository and
instead can be cloned from a separate remote repository.

## /e2e

A cypress e2e testing setup

- Requires backend to run in e2e testing mode, on `localhost:4000`
- Requires frontend to run in dev mode, on `localhost:3000`
- Once backend and frontend are running, run e2e tests using `npm run dashboard`

# I want to participate in the workshop

**What do I need to do to ensure I will be able to participate?**

Make sure you have the following environments setup on your machine

- erlang 23.3
- elixir >= 1.11.0 (if you are using **asdf**, make sure it's 1.12)
- nodejs >= 1.16.0 (if you are using **asdf**, make sure it's 1.16.0 exactly)
- postgres (tested on 12, but probably any relatively recent version is fine)

Clone the repository using one of the following:

- https://github.com/bego-talks/e2e-workshop.git
- git@github.com:bego-talks/e2e-workshop.git

Navigate to `/frontend` and make sure you can run it in dev mode

```
cd e2e-workshop/frontend
npm i
npm run dev
```

Navigate to `/backend` and make sure you can run it in E2E mode

```
cd e2e-workshop/backend
mix deps.get
MIX_ENV=e2e mix ecto.setup
MIX_ENV=e2e mix phx.server
```

This should allow you to follow the process of addinga Cypress testing suite
on top of the existing frontend and backend.

If you want to make sure you can run Cypress as well, navigate to `e2e` and
make sure youc an run it.

```
cd e2e-workshop/e2e
npm i
npm run dashboard
```

If you're seeing the cypress window, you're good to go.
# I want to add a cypress test suite of my own

To do this, we need to add e2e support to our backend and then setup a cypress
configuration. We then, of course, need to hook up the two together.

## Prepare the backend

### Setup the basic environment

Assuming `/backend` contains no code supporting e2e testing yet.

Create `backend/config/e2e.exs` and add the following to it

```Elixir
use Mix.Config

config :todo_list, env: :e2e

# The e2e environment endpoint is mostly like the dev environment endpoint
# It supports code reloading, for faster development and the ability to use
# the e2e suite as a constantly running tool.
config :todo_list, TodoListWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# The e2e environment repo is more like the test repo. It uses the sandbox
# pool to connect to the db.
config :todo_list, TodoList.Repo,
  username: "postgres",
  password: "postgres",
  database: "e2e_e2e",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
```

Add the following to `endpoint.ex`, after the call to `Plug.Telemetry`

```Elixir
is_e2e? = Application.get_env(:todo_list, :env) === :e2e

# CorsPlug is generally needed when the backend is served from a different
# endpoint to the frontend, but for e2e, we need to allow an extra header.
cors_headers =
  if is_e2e? do
    CORSPlug.defaults()[:headers] ++ ["sandbox"]
  else
    CORSPlug.defaults()[:headers]
  end

plug(CORSPlug, headers: cors_headers)

if is_e2e? do
  # Exposes endpoints to checkout a sandbox, generating a sandbox id, as
  # well as to check that sandbox back in
  plug(Phoenix.Ecto.SQL.Sandbox,
    at: "/sandbox",
    repo: TodoList.Repo,
    timeout: 60_000,
    header: "sandbox"
  )
end
```

This sets up a sandbox environment, and we can already run it, but there are two
more things we should do to facilitate testing

### Make sure the API is inacessible out of sandbox mode.

All API requests must be signed with a sandbox id, or they will go through to
the db and make permanent changes, causing subsequent runs to fail. We can
enforce this via a plug.

Since it's a plug used for testing, let's add the test support folder to compile
paths of our e2e environment in `mix.exs`

```Elixir
defp elixirc_paths(:test), do: ["lib", "test/support"]
defp elixirc_paths(:e2e), do: ["lib", "test/support"]
defp elixirc_paths(_), do: ["lib"]
```

Now, we can ceate `backend/test/support/plugs/sandbox_enforcer_plug.ex`

```Elixir
defmodule TodoList.SandboxEnforcerPlug do
  @behaviour Plug

  alias Plug.Conn

  require Logger

  def init(_) do
    [enabled: Application.get_env(:todo_list, :sql_sandbox, false)]
  end

  def call(conn, enabled: false), do: conn

  def call(conn, enabled: true) do
    sandbox_id = Conn.get_req_header(conn, "sandbox") |> List.wrap() |> List.first()

    case {conn.method, conn.request_path} do
      {"POST", "/api/sandbox"} -> log_sandbox_checkout(conn)
      {"DELETE", "/api/sandbox"} -> resolve_sandbox_checkin(conn, sandbox_id)
      {_method, "/socket" <> _path} -> conn
      {method, path} -> ensure_sandbox_id(conn, method, path, sandbox_id)
    end
  end

  defp log_sandbox_checkout(conn) do
    Conn.register_before_send(conn, fn before_send_conn ->
      Logger.warn("Checked out sandbox session #{before_send_conn.resp_body}")
      before_send_conn
    end)
  end

  defp resolve_sandbox_checkin(conn, nil) do
    message = "Attempting to check in a sandbox session, but no sandbox in headers, sent 400"
    Logger.error(message)

    conn |> Conn.send_resp(400, "Provide a valid sandbox header")
  end

  defp resolve_sandbox_checkin(conn, sandbox_id) do
    Logger.warn("Checking in sandbox session #{sandbox_id}")
    conn
  end

  defp ensure_sandbox_id(conn, method, path, nil) do
    message = "Attempting to #{method} #{path}, but no sandbox in headers, sent 400"
    Logger.error(message)
    conn |> Conn.send_resp(400, "Provide a valid sandbox header") |> Conn.halt()
  end

  defp ensure_sandbox_id(conn, method, path, sandbox_id) do
    Logger.warn("#{method} #{path}, sandbox: #{sandbox_id || "none"}")
    conn
  end
end
```

Lastly, we add this plug to `endpoint.ex`, right before `Phoenix.Ecto.SQL.Sandbox`

```Elixir
if is_e2e? do
  # Prevents all api requests without a sandbox id in
  # headers from going through.,
  plug(TodoList.SandboxEnforcerPlug)

  # ...

  plug(Phoenix.Ecto.SQL.Sandbox, ...)
end
```

### Expose ex_machina to the frontend, for easier test data setup

We need to expose an endpoint which would allow us to easily pre-create db
records in our test setup.

This is another useful thing we can do via a plug.

The default way ex_machina creates associations for a record is problematic, so
we need to create a custom factory for E2E specifically.

#### Custom factory

```Elixir
# backend/test/support/sandbox_factory.ex
defmodule TodoList.SandboxFactory do
  @moduledoc false

  use ExMachina.Ecto, repo: TodoList.Repo

  alias TodoList.{Accounts, Repo}
  alias TodoList.Factory, as: BaseFactory

  def user_factory(attrs) do
    BaseFactory.build(:user, attrs)
  end

  def todo_factory(attrs) do
    attrs
    |> assoc_by_id(:user, Accounts.User)
    |> do_build(:todo)
  end

  # If attrs has an association key, for example, attrs for todo have a `:user`,
  # and that association as a key `:id`, then load the associated record using
  # specified module and replace the association key with the loaded record.
  #
  # Otherwise, do nothing
  #
  # For example:
  #
  # ```
  # assoc_by_id([title: "Foo", user: %{id: 1}])
  #
  # > [title: "Foo", user: %TodoList.Accounts.User{id: 1}]
  # ```
  defp assoc_by_id(attrs, assoc_key, module) do
    with %{} = assoc <- attrs[assoc_key],
         id when not is_nil(id) <- assoc[:id] do
      attrs |> Map.put(assoc_key, Repo.get(module, id))
    else
      nil -> attrs
    end
  end

  defp do_build(attrs, schema) do
    BaseFactory.build(schema, attrs)
  end
end
```

#### Factory plug

```Elixir
# backend/test/support/plugs/factory_plug.ex

defmodule TodoList.FactoryPlug do
  @moduledoc false
  @behaviour Plug

  alias Plug.Conn
  alias TodoList.SandboxFactory

  def init(_) do
    Application.start(:ex_machina)
  end

  # add a /factory endpoint for record creation
  def call(%Conn{method: "POST", request_path: "/factory"} = conn, _) do
    # params must contain "schema" and "attributes"
    with {:ok, schema} <- Map.fetch(conn.body_params, "schema"),
         {:ok, attrs} <- Map.fetch(conn.body_params, "attributes") do
      # attributes and schema are converted to atoms,
      # to more easily pass them into factory
      db_schema = String.to_atom(schema)
      db_attrs = atomize(attrs)

      # if params optionally contain "count", we create a list of records
      rendered =
        db_schema
        |> create(db_attrs, Map.get(conn.body_params, "count"))
        |> Jason.encode!()

      Conn.send_resp(conn, 200, rendered) |> Conn.halt()
    else
      _ -> Conn.send_resp(conn, 401, "schema or attributes missing") |> Conn.halt()
    end
  end

  def call(%Conn{} = conn, _), do: conn

  @spec create(atom, list(map) | map, nil | integer) :: struct | list(struct)
  def create(schema, attrs, nil) when is_list(attrs) do
    Enum.map(attrs, &create(schema, &1, nil))
  end

  def create(schema, %{} = attrs, nil) do
    SandboxFactory.insert(schema, attrs)
  end

  def create(schema, %{} = attrs, count) do
    SandboxFactory.insert_list(count, schema, attrs)
  end

  @spec atomize(any) :: any
  defp atomize(%{} = attrs) do
    attrs
    |> Enum.map(fn {k, v} -> {String.to_atom(k), atomize(v)} end)
    |> Map.new()
  end

  defp atomize(attrs) when is_list(attrs) do
    Enum.map(attrs, &atomize/1)
  end

  defp atomize(v), do: v
end
```

#### Add the plug to our endpoint

```Elixir
# backend/lib/todo_list_web/endpoint.ex
# new code block. right after `Plug.Head`, before `Plug.Session`
plug(Plug.Head)

if is_e2e? do
  # Exposes additional endpoints to easily create db records
  # needed for test setup.
  plug(TodoList.FactoryPlug)
end

plug(Plug.Session, @session_options)
```

Now, we also have factory support



## Add a cypress setup

**NOTE:** The existing `/e2e` folder already contains a fully setup
environment. This explains how to set one up from scratch.
### Create a folder with a name of your choice. In this example.

```bash
cd e2e-workshop
mkdir cypress
cd cypress
```

###  Initialize an npm project

NOTE: We are setting up basic linting and typescript support here as well. Some
of these things could be skipped.

```bash
npm init
npm -i --save-dev \
  @typescript-eslint/eslint-plugin \
  @typescript-eslint/parser \
  cypress \
  eslint-plugin-cypress \
  typescript \
```

At this point, you should have a bunch of example test cases and should be able
to run cypress using `npx cypress:open`

### Add the recommended configuration files

`eslintrc.js`

```js
module.exports = {
  plugins: [
    'cypress',
  ],
  env: {
    'cypress/globals': true,
  },
};
```

`tsconfig.json`
```json
{
  "compilerOptions": {
    "types": ["cypress"]
  },
  "include": ["**/*.ts"]
}
```

`cypress.json`

```json
{
  "baseUrl": "http://localhost:3000"
}
```

### Delete all examples

`cypress/actions/examples` contains a lot of useful stuff, so make sure to have
a look, but since we've added typescript, rather than convertimg them, let's
just remove them all.

### Convert all .js files in `cypress` to .ts

A simple rename should suffice here, provided the remaining steps were followed
correctly.

## Hookup cypress with the backend

We want to make use of sandbox mode provided by the backend. For that, we can
create custom cypress commands.

Now, we need to add a few commands to support e2e features given by the backend.

Note that these commands build on top of built-in cypress commands. Be sure to
refer to the high-quality documentation provided by the cypress team to learn
more about them.

[Cypress API Docs](https://docs.cypress.io/api/commands/and)

We add these commands to `cypress/support/commands.ts`

### Command to checkout a sandbox session from our backend and get the id

```typescript
// Helper function to build a URL targeting our backend, from a path
const apiUrl = (path: string) => `http://localhost:4000/${path}`;

Cypress.Commands.add("checkoutSandbox", () =>
  cy.request("POST", apiUrl("sandbox")).then((response) => {
    Cypress.env("sandboxId", response.body);
  })
);
```
*Note the helper `apiUrl` function. In a real life scenario, we would probably
set the base api url via an environment variable or something similar.*

We can use this command using `cy.checkoutSandbox()`. The id will be stored
into the cypress environment for the test and will be accessible to other
commands if necessary.

This should run at the start of every test.

### Command to specify the test should use sandbox mode

```typescript
Cypress.Commands.add("useSandbox", () =>
  cy.intercept({ url: "http://localhost:4000/**" }, (req) => {
    const sandboxId = Cypress.env("sandboxId");
    if (sandboxId) {
      req.headers["sandbox"] = sandboxId;
    }
    req.continue();
  })
);
```

`cy.intercept` allows us to intercept all network requests and optionally modify
them. In this case, we add a header to all of them, which is the id of the
sandbox session, which we stored into the environment.

This should also run at the start of every test, but **after**
`cy.checkoutSandbox()`.

### Command to close the checked out sandbox session

```typescript
Cypress.Commands.add("checkinSandbox", () =>
  cy.request({
    method: "DELETE",
    url: apiUrl("sandbox"),
    headers: { Sandbox: Cypress.env("sandboxId") },
  })
);
```

This should run **at the end** of every test.

### Command to create db records using the factory endpoint

```typescript
const createRequest = (schema: string, attributes: {}) => ({
  method: "POST",
  url: apiUrl("factory"),
  body: { schema, attributes },
  headers: { Sandbox: Cypress.env("sandboxId") },
});

Cypress.Commands.add("create", (recordType: string, attributes: Record<string, any>) =>
  cy.request(createRequest(recordType, attributes)).its("body")
);
```

We define the callback separately here, to make things a bit easier to read.
The command simply sends a request to the factory record and chains back the
response.

Example usage:

```typescript
cy.create('user', { name: 'Joe', password: 'password1' })
cy.create('todo', { title: 'Buy Milk', user: { id: 1 } })
```

### Make all commands typescript-valid

To have these commands be recognized by typescript, we need to add a type
definition file.

Let's add `cypress/support/index.d.ts`

```typescript
declare namespace Cypress {
  interface Chainable<Subject> {
    useSandbox(): Chainable<void>;
    checkoutSandbox(): Chainable<string>;
    checkinSandbox(): Chainable<void>;
    create<T = Record<string, any>, R = any>(type: String, params: T): Chainable<R>;
  }
}
```

## Create a basic test

Now let's write a test which checks if account registration works.

We add a new file `cypress/integration/register.spec.ts`

```typescript
/// <reference types="cypress" />
/// <reference types="../support" />

describe("Register", () => {
})
```

This defines a test suite. Now let's add a test into the describe block

```typescript
describe("Register", () => {
  beforeEach(() => {
    cy.useSandbox();
    cy.checkoutSandbox();
  });

  afterEach(() => {
    cy.checkinSandbox();
  });

  it("registers user", () => {
    cy.visit('/register');
    cy.get(".register input[name=name]").clear().type(value);
    cy.get(".register input[name=password]").clear().type(value);
    cy.get(".register button").click();
    cy.url().should("not.contain", "register");
  });
})
```

So what the test does is, it
- navigates our frontend app to `/register`
- fills in `'Joe'` as new user's name
- fills in `'password1'` as new user's password
- clicks the create button
- checks that we got redirected away from the page (meaning it was ok)

It's a very simple test, but it shuould start us off on the right foot.

## Run the test

Let's see if we can run this test.

Open a terminal tab, navigate to backend and run it in e2e mode

```bash
cd e2e-workshop/backend
MIX_ENV=e2e mix phx.server
```

Open another terminal tab, navigate to frontend and run it in dev mode

```bash
cd e2e-workshop/frontend
mix run dev
```

Finally, open a third tap, navigate to our new cypress folder and run the
cypress dashboard

```bash
cd e2e-workshop/e2e_new
npx cypress open
```

If it all went well, and the instructions are accurate, your test should now run
and succeed.

If it didn't, here's a couple of thins you could do to debug

- ensure you ran backend with `MIX_ENV=e2e`
- check for any errors in the backend or frontend terminal
- if the test is running, but is failing, use the replay feature given by
  cypress, to figure out what's wrong
  - is the `sandbox` header being added to backend requests? You wont' be able
    to see it from the browser network tab because it's outside of the browser,
    but you can see it by clicking on the request in replay and checking the
    console output.



# I want to do more.

Awesome!

First thing to recommend is to check out the `e2e` folder in this repository.
It contains a fully setup and thoroughly documented cypress testing environment.

It also makes use of the concept of page objects in testing. These are basically
abstractions around the common actions you simulate in your test, so you can
reuse and manage them more easily.

They are usually structured around sections of UI, which is the case in this
example.

A good exercise would be to write more tests. For example, we don't really test
error handling at all.

The frontend and backend aren't that complex, though, so maybe another thing
would be to add more features to those, which we can then test.

Do note that **contributions to the repo are more then welcome**. If we can make
this useful as more than just a thing for a workshop, I would be happy to accept
the contributions.
