defmodule SentientSocial do
  alias SentientSocial.Boundary.TweetMapper
  alias SentientSocial.Core.TweetFilter

  @search_fn Application.get_env(:sentient_social, :search_fn)
  @favorite_fn Application.get_env(:sentient_social, :favorite_fn)
  @term_provider_fn Application.get_env(:sentient_social, :term_provider_fn)

  def find_and_favorite_tweets(
        search_fn \\ @search_fn,
        term_provider_fn \\ @term_provider_fn,
        favorite_fn \\ @favorite_fn
      ) do
    term_provider_fn.()
    |> Enum.map(fn term ->
      search_fn.(term)
      |> Enum.map(&TweetMapper.map/1)
      |> TweetFilter.filter()
      |> InlineLogger.info(label: "potential favorites")
      |> Enum.random()
      |> InlineLogger.info(label: "favorited tweet")
      |> create_favorite(favorite_fn)
    end)
    |> List.flatten()
  end

  def find_tweets(search_fn \\ @search_fn, term_provider_fn \\ @term_provider_fn) do
    term_provider_fn.()
    |> Enum.map(fn term -> search_fn.(term) end)
    |> List.flatten()
    |> Enum.map(&TweetMapper.map/1)
    |> TweetFilter.filter()
  end

  def create_favorite(tweet, favorite_fn \\ @favorite_fn)

  def create_favorite(nil, _), do: nil

  def create_favorite(%{id: id}, favorite_fn) do
    id
    |> favorite_fn.()
    |> TweetMapper.map()
  end
end
