defmodule SentientSocial.SearchTermProvider do
  @callback terms() :: list(String.t())
end

defmodule SentientSocial.SearchTermProvider.InMemory do
  @behaviour SentientSocial.SearchTermProvider

  def terms do
    [
      "#100DaysOfCode",
      "#301DaysOfCode",
      "#BaseCS",
      "#CodeNewbie",
      "#GirlsWhoCode",
      "#MyElixirStatus"
    ]
  end
end
