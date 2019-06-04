defmodule SentientSocial.Twitter do
  require Logger

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  def favorite_tweet_by_search_term(user, search_term) do
    case @twitter_client.search(search_term, count: 1) do
      [] ->
        {:error, "No tweets found matching that search term."}

      [tweet] ->
        favorite_tweet(user, tweet)
    end
  end

  defp favorite_tweet(_user, %{favorited: true}),
    do: {:error, "No tweets found matching that search term."}

  defp favorite_tweet(user, %{id: tweet_id} = tweet) do
    set_user_access_tokens(user)

    try do
      tweet = @twitter_client.create_favorite(tweet_id, [])
      Logger.info("favorited a tweet for user_id #{user.id}: #{inspect(tweet)}")

      {:ok, tweet}
    rescue
      e in ExTwitter.Error ->
        # Twitter API is bullshit and doesn't always return %{favorited: true} when you've already favorited a tweet.
        # ExTwitter raises when you try to favorite a tweet that you've already favorited.
        Logger.info(
          "Error favoriting tweet for user_id #{user.id}. \n Error: #{inspect(e)} \n Tweet: #{
            inspect(tweet)
          } \n"
        )

        {:error, "We had some trouble favoriting that tweet for you."}
    end
  end

  defp set_user_access_tokens(user) do
    %{token: %{token: token, token_secret: secret}} = user

    :ok =
      @twitter_client.configure(
        :process,
        Enum.concat(
          @twitter_client.get_tuples(),
          access_token: token,
          access_token_secret: secret
        )
      )
  end
end
