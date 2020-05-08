defmodule SentientSocial.Core.TweetChooserTest do
  use ExUnit.Case, async: true
  alias SentientSocial.Core.TweetChooser
  alias SentientSocial.Factory

  describe "choose/1" do
    test "picks one of the given tweets" do
      tweets = [
        Factory.build_tweet(id: 1),
        Factory.build_tweet(id: 2),
        Factory.build_tweet(id: 3),
        Factory.build_tweet(id: 4)
      ]

      chosen_tweet = TweetChooser.choose(tweets)

      assert Enum.member?(tweets, chosen_tweet)
    end
  end
end
