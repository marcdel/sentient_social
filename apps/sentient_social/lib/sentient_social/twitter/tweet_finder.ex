defmodule SentientSocial.Twitter.TweetFinder do
  @moduledoc """
  Finds tweets matching the specified user's keywords
  """

  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  @doc """
  Finds tweets for the given user's keywords
  """
  @spec find_tweets(%User{}) :: [%ExTwitter.Model.Tweet{}]
  def find_tweets(user) do
    user
    |> Accounts.list_keywords()
    |> Enum.flat_map(fn keyword ->
      @twitter_client.search(keyword.text, count: 1)
    end)
  end
end
