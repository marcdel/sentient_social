defmodule SentientSocial.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: SentientSocial.Repo

  alias ExTwitter.Model.Tweet
  alias SentientSocial.Accounts.{User, Keyword}
  alias SentientSocial.Twitter.{AutomatedInteraction, HistoricalFollowerCount}

  def user_factory do
    %User{
      name: "John Doe",
      profile_image_url: "www.website.com/image.png",
      username: sequence(:username, &"johndoe#{&1}"),
      email: sequence(:email, &"johndoe#{&1}@email.com"),
      access_token: "token",
      access_token_secret: "secret"
    }
  end

  def historical_follower_count_factory do
    %HistoricalFollowerCount{
      count: sequence(:historical_follower_count, &"#{&1}"),
      user: build(:user)
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
      undo_at: Date.utc_today() |> Date.add(7),
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

  def ex_twitter_extended_tweet_factory do
    %Tweet{
      id: 1,
      full_text: "Tweet #keyword1 text",
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

  @spec make_invalid(%Tweet{}) :: %Tweet{}
  def make_invalid(%Tweet{retweeted_status: nil, full_text: nil, text: nil} = tweet), do: tweet

  def make_invalid(%Tweet{retweeted_status: nil, full_text: nil} = tweet) do
    {new_text, new_entities} = make_new_text_and_entities()
    %{tweet | text: new_text, entities: new_entities}
  end

  def make_invalid(%Tweet{retweeted_status: nil, text: nil} = tweet) do
    {new_text, new_entities} = make_new_text_and_entities()
    %{tweet | full_text: new_text, entities: new_entities}
  end

  def make_invalid(%Tweet{retweeted_status: %{full_text: nil}} = tweet) do
    {new_text, new_entities} = make_new_text_and_entities()
    %{tweet | retweeted_status: %{text: new_text, entities: new_entities}}
  end

  def make_invalid(%Tweet{retweeted_status: %{text: nil}} = tweet) do
    {new_text, new_entities} = make_new_text_and_entities()
    %{tweet | retweeted_status: %{full_text: new_text, entities: new_entities}}
  end

  defp make_new_text_and_entities do
    hashtags = [
      sequence(:hashtag, &"hashtag-#{&1}"),
      sequence(:hashtag, &"hashtag-#{&1}"),
      sequence(:hashtag, &"hashtag-#{&1}"),
      sequence(:hashtag, &"hashtag-#{&1}"),
      sequence(:hashtag, &"hashtag-#{&1}"),
      sequence(:hashtag, &"hashtag-#{&1}")
    ]

    new_text = hashtags |> Enum.join(" ") |> IO.iodata_to_binary()
    new_entities = %{hashtags: hashtags |> Enum.map(fn hashtag -> %{text: hashtag} end)}

    {new_text, new_entities}
  end

  @spec make_retweet(%Tweet{}) :: %Tweet{}
  def make_retweet(tweet) do
    %{
      tweet
      | retweeted_status: %{
          text: tweet.text,
          full_text: tweet.full_text,
          entities: tweet.entities,
          user: tweet.user
        }
    }
  end
end
