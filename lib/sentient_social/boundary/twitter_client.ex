defmodule SentientSocial.Boundary.TwitterClientBehavior do
  @callback search(String.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback search(String.t(), result_count: integer()) :: [ExTwitter.Model.Tweet.t()]
end

defmodule SentientSocial.Boundary.TwitterClient do
  @behaviour SentientSocial.Boundary.TwitterClientBehavior

  def search(query) do
    search(query, result_count: 100)
  end

  def search(query, result_count: count) do
    ExTwitter.search(query, count: count, include_entities: true, tweet_mode: :extended)
  end
end
