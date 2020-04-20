defmodule SentientSocial.Core.Tweet do
  defstruct id: nil,
            text: nil,
            hashtags: [],
            retweet?: false,
            truncated?: false,
            favorited?: false
end
