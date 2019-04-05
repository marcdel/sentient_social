defmodule SentientSocialWeb.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use SentientSocialWeb.ConnCase
      use PhoenixIntegration
    end
  end
end
