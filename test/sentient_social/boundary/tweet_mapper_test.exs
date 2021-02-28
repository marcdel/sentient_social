defmodule SentientSocial.Boundary.TweetMapperTest do
  use ExUnit.Case, async: true
  alias SentientSocial.Factory
  alias SentientSocial.Boundary.TweetMapper

  test "map/1" do
    standard_tweet =
      Factory.build_external_tweet(
        id: 123_456,
        text: "Sample tweet text #tweep",
        retweeted_status: nil,
        entities: %ExTwitter.Model.Entities{
          hashtags: [%ExTwitter.Model.Hashtag{text: "tweep"}]
        }
      )

    %{
      id: 123_456,
      text: "Sample tweet text #tweep",
      hashtags: ["tweep"],
      retweet?: false,
      truncated?: false,
      favorited?: false
    } = TweetMapper.map(standard_tweet)

    retweet = Factory.build_external_tweet(retweeted_status: Factory.build_external_tweet())

    assert %{retweet?: true} = TweetMapper.map(retweet)

    favorited_tweet = Factory.build_external_tweet(favorited: true)

    assert %{favorited?: true} = TweetMapper.map(favorited_tweet)

    truncated_tweet = Factory.build_external_tweet(truncated: true)

    assert %{truncated?: true} = TweetMapper.map(truncated_tweet)

    full_text_tweet =
      Factory.build_external_tweet(
        full_text: "sometimes tweets have the full_text field instead",
        text: nil
      )

    assert %{text: "sometimes tweets have the full_text field instead"} =
             TweetMapper.map(full_text_tweet)
  end

  test "when error returns nil" do
    assert TweetMapper.map(%RuntimeError{message: "oops"}) == nil
  end
end
