defmodule SentientSocialWeb.IntegrationCase do
  @moduledoc """
  Adds PhoenixIntegration to the ConnCase
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      use SentientSocialWeb.ConnCase
      use PhoenixIntegration
    end
  end
end
