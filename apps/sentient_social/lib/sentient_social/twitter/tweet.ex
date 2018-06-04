defmodule SentientSocial.Twitter.Tweet do
  @moduledoc """
  Tweet object.

  ## Reference
  https://dev.twitter.com/overview/api/tweets
  """

  defstruct id: nil, text: nil, user_id: nil, screen_name: nil, description: nil, hashtags: []

  @spec new(%ExTwitter.Model.Tweet{}) :: %SentientSocial.Twitter.Tweet{}
  def new(ex_twitter_tweet) do
    %{
      id: id,
      text: text,
      full_text: full_text,
      user: %{id: user_id, screen_name: screen_name, description: description},
      entities: %{hashtags: hashtags}
    } = ex_twitter_tweet

    %__MODULE__{
      id: id,
      text: full_text || text,
      user_id: user_id,
      screen_name: screen_name,
      description: description,
      hashtags: Enum.map(hashtags, fn hashtag -> hashtag.text end)
    }
  end
end
