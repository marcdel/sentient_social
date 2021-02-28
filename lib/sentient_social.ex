defmodule SentientSocial do
  use OpenTelemetryDecorator

  alias SentientSocial.Boundary.TweetMapper
  alias SentientSocial.Core.{TweetChooser, TweetFilter}

  @search_fn Application.get_env(:sentient_social, :search_fn)
  @favorite_fn Application.get_env(:sentient_social, :favorite_fn)
  @term_provider_fn Application.get_env(:sentient_social, :term_provider_fn)

  @decorate trace("sentient_social.find_and_favorite_tweets")
  def find_and_favorite_tweets(
        previously_favorited_tweets,
        search_fn \\ @search_fn,
        term_provider_fn \\ @term_provider_fn,
        favorite_fn \\ @favorite_fn
      ) do
    term_provider_fn.()
    |> Enum.map(fn term ->
      search_fn.(term)
      |> Enum.map(&TweetMapper.map/1)
      |> TweetFilter.filter(previously_favorited_tweets)
      |> TweetChooser.choose()
      |> create_favorite(favorite_fn)
      |> InlineLogger.info(label: "favorited tweet")
    end)
    |> Enum.reject(&is_nil/1)
    |> List.flatten()
  end

  def create_favorite(tweet, favorite_fn \\ @favorite_fn)

  def create_favorite(nil, _), do: nil

  @decorate trace("sentient_social.create_favorite", include: [:tweet])
  def create_favorite(%{id: id} = tweet, favorite_fn) do
    id
    |> favorite_fn.()
    |> TweetMapper.map()
  end
end
