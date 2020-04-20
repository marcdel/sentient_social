defmodule SentientSocial.Factory do
  def build_external_tweet(params \\ []) do
    defaults = %ExTwitter.Model.Tweet{
      text: "Sample tweet text #tweep",
      entities: %ExTwitter.Model.Entities{
        hashtags: [%ExTwitter.Model.Hashtag{text: "tweep"}]
      }
    }

    Map.merge(defaults, Enum.into(params, %{}))
  end

  def build_tweet(params \\ []) do
    defaults = %SentientSocial.Core.Tweet{
      text: "Sample tweet text #tweep",
      hashtags: ["tweep"]
    }

    Map.merge(defaults, Enum.into(params, %{}))
  end
end
