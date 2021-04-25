# e2e-workshop

Holds lesson notes and code needed to hold or participate in a workshop setting
up an E2E flow in a scenario where the frontend and backend are separate
repositories.

# file organization

## /backend

An elixir+phoenix backend which is a simple todo creation api

- tests can be run using `mix test`
- backend can be started using `mix phx.server`

## /frontend

A vue3 + vue-router4 + vuex4 + vite frontend, directly integrated
with the backend.

- runs in dev mode using `npx dev`
