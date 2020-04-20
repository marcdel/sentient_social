defmodule SentientSocial.Boundary.TweetMapper do
  @moduledoc """
  Maps a tweet object from the external ExTwitter representation to
  one that is more easily digestible, with only the values we need.
  """

  def map(%ExTwitter.Model.Tweet{} = tweet) do
    %SentientSocial.Core.Tweet{
      id: tweet.id,
      text: get_text(tweet),
      hashtags: hashtags_text(tweet),
      retweet?: tweet.retweeted_status != nil,
      favorited?: tweet.favorited == true,
      truncated?: tweet.truncated == true
    }
  end

  defp get_text(%{text: text, full_text: nil}), do: text
  defp get_text(%{text: nil, full_text: text}), do: text

  defp hashtags_text(tweet) do
    Enum.map(tweet.entities.hashtags, fn hashtag -> hashtag.text end)
  end
end
