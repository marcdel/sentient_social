defmodule SentientSocial.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: SentientSocial.Repo

  alias SentientSocial.Accounts.{User, Keyword}

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
      user: build(:user)
    }
  end
end
