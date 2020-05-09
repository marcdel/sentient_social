defmodule SentientSocial.Core.TweetChooser do
  def choose([]), do: nil

  def choose(tweets) do
    Enum.random(tweets)
  end
end
