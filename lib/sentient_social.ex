defmodule SentientSocial do
  alias SentientSocial.Boundary.TweetMapper
  alias SentientSocial.Core.TweetFilter

  @search_fn Application.get_env(:sentient_social, :search_fn)
  @term_provider_fn Application.get_env(:sentient_social, :term_provider_fn)

  def find_tweets(search_fn \\ @search_fn, term_provider_fn \\ @term_provider_fn) do
    term_provider_fn.()
    |> Enum.map(fn term -> search_fn.(term) end)
    |> List.flatten()
    |> Enum.map(&TweetMapper.map/1)
    |> TweetFilter.filter()
  end
end
