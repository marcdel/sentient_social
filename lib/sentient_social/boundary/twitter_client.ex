defmodule SentientSocial.Boundary.TwitterClientBehavior do
  @callback search(String.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback search(String.t(), result_count: integer()) :: [ExTwitter.Model.Tweet.t()]
  @callback create_favorite(number()) :: ExTwitter.Model.Tweet.t()
end

defmodule SentientSocial.Boundary.TwitterClient do
  use OpenTelemetryDecorator

  @behaviour SentientSocial.Boundary.TwitterClientBehavior

  def search(query) do
    search(query, result_count: 100)
  end

  @decorate trace("twitter_client.search", include: [:query, :count])
  def search(query, result_count: count) do
    found = ExTwitter.search(query, count: count, include_entities: true, tweet_mode: :extended)
    O11y.set_attribute("found", Enum.count(found))
    found
  rescue
    error ->
      O11y.set_attribute("error", error)
      []
  end

  @decorate trace("twitter_client.create_favorite", include: [:id])
  def create_favorite(id) do
    ExTwitter.create_favorite(id, include_entities: true)
  rescue
    error -> O11y.set_attribute("error", error)
  end
end
