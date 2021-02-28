defmodule SentientSocial.Core.TweetChooser do
  use OpenTelemetryDecorator

  @decorate trace("tweet_chooser.choose", include: [:result])
  def choose([]), do: nil

  @decorate trace("tweet_chooser.choose", include: [:result])
  def choose(tweets) do
    Enum.random(tweets)
  end
end
