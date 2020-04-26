defmodule SentientSocial.SearchTermProvider do
  @callback terms() :: list(String.t())
end

defmodule SentientSocial.SearchTermProvider.InMemory do
  @behaviour SentientSocial.SearchTermProvider

  def terms, do: ["#CodeNewbie"]
end
