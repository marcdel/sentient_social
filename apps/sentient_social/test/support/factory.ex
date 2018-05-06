defmodule SentientSocial.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: SentientSocial.Repo

  alias ExTwitter.Model.Tweet
  alias SentientSocial.Accounts.{User, Keyword}
  alias SentientSocial.Twitter.AutomatedInteraction

  def user_factory do
    %User{
      name: "John Doe",
      profile_image_url: "www.website.com/image.png",
      username: sequence(:username, &"johndoe#{&1}"),
      access_token: "token",
      access_token_secret: "secret"
    }
  end

  def keyword_factory do
    %Keyword{
      text: sequence(:text, &"hashtag-#{&1}"),
      muted: false,
      user: build(:user)
    }
  end

  def muted_keyword_factory do
    %Keyword{
      text: sequence(:text, &"hashtag-#{&1}"),
      muted: true,
      user: build(:user)
    }
  end

  def automated_interaction_factory do
    %AutomatedInteraction{
      tweet_text: sequence(:text, &"tweet with hashtag-#{&1}"),
      tweet_url: sequence(:tweet_url, &"www.twitter.com/i/web/status/#{&1}"),
      tweet_user_screen_name: sequence(:text, &"user_#{&1}"),
      interaction_type: "favorite",
      user: build(:user)
    }
  end

  def ex_twitter_tweet_factory do
    %Tweet{
      id: 1,
      text: "Tweet #keyword1 text",
      entities: %{
        hashtags: [
          %{text: "keyword1"}
        ]
      },
      user: build(:ex_twitter_user)
    }
  end

  def ex_twitter_user_factory do
    %ExTwitter.Model.User{
      screen_name: "user",
      description: "description"
    }
  end

  @spec make_retweet(%Tweet{}) :: %Tweet{}
  def make_retweet(tweet) do
    %{
      tweet
      | retweeted_status: %{
          text: tweet.text,
          entities: tweet.entities,
          user: tweet.user
        }
    }
  end
end
