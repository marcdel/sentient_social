defmodule SentientSocial.Twitter.TwitterClient do
  @moduledoc false

  alias ExTwitter.Model.User
  alias SentientSocial.Twitter.Tweet

  @callback search(String.t(), count: integer, tweet_mode: String.t()) ::
              [%Tweet{}] | {:error, String.t()}
  @callback user(String.t() | integer) :: {:ok, %User{}}
  @callback create_favorite(Integer) :: {:ok, %Tweet{}} | {:error, String.t()}
  @callback destroy_favorite(Integer) :: {:ok, %Tweet{}} | {:error, String.t()}
end
