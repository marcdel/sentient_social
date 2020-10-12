defmodule SentientSocial.SearchTermProvider do
  @callback terms() :: list(String.t())
end

defmodule SentientSocial.SearchTermProvider.InMemory do
  @behaviour SentientSocial.SearchTermProvider

  def terms do
    [
      "#CodeNewbie",
      "#100DaysOfCode",
      "#BaseCS",
      "#GirlsWhoCode",
      "#MyElixirStatus",
      "#301DaysOfCode"
    ]
  end
end
