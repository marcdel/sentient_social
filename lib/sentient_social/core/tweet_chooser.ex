defmodule SentientSocial.Core.TweetChooser do
  def choose(tweets) do
    Enum.random(tweets)
  end
end
