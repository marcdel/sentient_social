defmodule SentientSocial.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: SentientSocial.Repo

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
      tweet_text: sequence(:text, &"hashtag-#{&1}"),
      tweet_user_handle: sequence(:text, &"user_#{&1}"),
      interaction_type: "favorite",
      user: build(:user)
    }
  end
end
