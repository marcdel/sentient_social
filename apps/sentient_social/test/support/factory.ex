defmodule SentientSocial.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: SentientSocial.Repo

  alias SentientSocial.Accounts.{User, Keyword}
  alias SentientSocial.Twitter.{Tweet, AutomatedInteraction, HistoricalFollowerCount}

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

  def tweet_factory do
    %Tweet{
      id: sequence(:id, &"#{&1}"),
      text: sequence(:screen_name, &"Tweet #keyword#{&1} text"),
      hashtags: [sequence(:hashtag, &"keyword#{&1}")],
      user_id: sequence(:user_id, &"#{&1}"),
      screen_name: sequence(:screen_name, &"johndoe#{&1}")
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
      tweet_text: sequence(:tweet_text, &"tweet with hashtag-#{&1}"),
      tweet_url: sequence(:tweet_url, &"www.twitter.com/i/web/status/#{&1}"),
      tweet_user_id: sequence(:tweet_user_id, &"#{&1}"),
      tweet_user_screen_name: sequence(:tweet_user_screen_name, &"user_#{&1}"),
      interaction_type: "favorite",
      undo_at: Date.utc_today() |> Date.add(7),
      undone: false,
      user: build(:user)
    }
  end
end
