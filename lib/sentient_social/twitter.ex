defmodule SentientSocial.Twitter do
  require Logger

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  def favorite_tweets_by_search_terms(search_terms, user) do
    set_user_access_tokens(user)

    search_terms
    |> find_tweets()
    |> favorite_tweets(user)
    |> format_response()
  end

  defp find_tweets(search_terms) do
    search_terms
    |> Enum.map(&Task.async(fn -> @twitter_client.search(&1, count: 1) end))
    |> Enum.flat_map(&Task.await(&1))
  end

  defp favorite_tweets([], _user), do: [{:error, "No tweets found matching that search term."}]

  defp favorite_tweets(tweets, user) do
    tweets
    |> Enum.map(&Task.async(fn -> &1 |> fetch_extended_info() |> favorite_tweet(user) end))
    |> Enum.map(&Task.await(&1))
  end

  defp format_response(results) do
    default_response = %{success_count: 0, error_count: 0, error_messages: [], tweets: []}

    Enum.reduce(results, default_response, fn
      {:error, message}, acc ->
        %{acc | error_count: acc.error_count + 1, error_messages: [message | acc.error_messages]}

      {:ok, tweet}, acc ->
        %{acc | success_count: acc.success_count + 1, tweets: [tweet | acc.tweets]}
    end)
  end

  defp fetch_extended_info(%{retweeted_status: tweet}) when not is_nil(tweet),
    do: fetch_extended_info(tweet)

  defp fetch_extended_info(%{quoted_status: tweet}) when not is_nil(tweet),
    do: fetch_extended_info(tweet)

  defp fetch_extended_info(%{id: id}) do
    @twitter_client.show(id, include_entities: true, tweet_mode: :extended)
  end

  defp favorite_tweet(%{favorited: true}, _user),
    do: {:error, "No new tweets found matching that search term."}

  defp favorite_tweet(%{retweeted_status: tweet}, user) when not is_nil(tweet),
    do: favorite_tweet(tweet, user)

  defp favorite_tweet(%{quoted_status: tweet}, user) when not is_nil(tweet),
    do: favorite_tweet(tweet, user)

  defp favorite_tweet(tweet, user) do
    set_user_access_tokens(user)

    try do
      tweet = @twitter_client.create_favorite(tweet.id, [])
      Logger.info("favorited a tweet for user_id #{user.id}: #{inspect(tweet)}")

      {:ok, tweet}
    rescue
      e in ExTwitter.Error ->
        # ExTwitter raises when you try to favorite a tweet that you've already favorited.
        Logger.info(
          "Error favoriting tweet for user_id #{user.id}. \n Error: #{inspect(e)} \n Tweet: #{
            inspect(tweet)
          } \n"
        )

        {:error, "We had some trouble favoriting that tweet for you."}
    end
  end

  defp set_user_access_tokens(%{id: user_id, token: nil}),
    do: {:error, "User #{user_id} does not have a token"}

  defp set_user_access_tokens(%{id: user_id, token: %{token: nil}}),
    do: {:error, "User #{user_id} does not have valid a token"}

  defp set_user_access_tokens(%{id: user_id, token: %{token_secret: nil}}),
    do: {:error, "User #{user_id} does not have valid a token"}

  defp set_user_access_tokens(%{token: %{token: token, token_secret: secret}}) do
    user_config =
      Enum.concat(@twitter_client.get_tuples(), access_token: token, access_token_secret: secret)

    :ok = @twitter_client.configure(:process, user_config)
  end
end
