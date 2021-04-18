defmodule E2E.E2ECase do
  @moduledoc """
  This module defines the setup for e2e tests
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      use Wallaby.Feature
    end
  end
end
