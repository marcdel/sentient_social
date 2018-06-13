defmodule SentientSocial.Twitter.RateLimitedTwitterClient do
  @moduledoc """
  Wrapper for the ExTwitterClient that also implements rate limiting
  """

  alias SentientSocial.Accounts.User
  alias SentientSocial.Twitter.Tweet

  @twitter_client Application.get_env(:sentient_social, :twitter_client)
  @rate_limiter Application.get_env(:sentient_social, :rate_limiter)

  @time_scale 60_000 * 15
  @defaults [count: 10, rate_limit: 15, tweet_mode: "extended"]

  @doc """
  Search for tweets matching the specified string
  """
  @spec search(String.t(), %User{}, count: integer, rate_limit: integer) ::
          [%Tweet{}] | {:deny, integer} | {:error, String.t()}
  def search(query, user, options \\ []) do
    options = Keyword.merge(@defaults, options)

    with {:allow, _} <- check_rate_limit(user, options[:rate_limit]) do
      @twitter_client.search(query, options)
    end
  end

  @doc """
  Get user information by id
  """
  @spec user(%User{}, rate_limit: integer) ::
          {:ok, %User{}} | {:deny, integer} | {:error, ExTwitter.Error}
  def user(user, options \\ []) do
    options = Keyword.merge(@defaults, options)

    with {:allow, _} <- check_rate_limit(user, options[:rate_limit]) do
      @twitter_client.user(user.username)
    end
  end

  @doc """
  Favorite the specified tweet by id and return an :ok or an :error tuple
  """
  @spec create_favorite(integer, %User{}, rate_limit: integer) ::
          {:ok, %Tweet{}} | {:deny, integer} | {:error, ExTwitter.Error}
  def create_favorite(tweet_id, user, options \\ []) do
    options = Keyword.merge(@defaults, options)

    with {:allow, _} <- check_rate_limit(user, options[:rate_limit]) do
      @twitter_client.create_favorite(tweet_id)
    end
  end

  @doc """
  Unfavorite the specified tweet by id and return an :ok or an :error tuple
  """
  @spec destroy_favorite(integer, %User{}, rate_limit: integer) ::
          {:ok, %Tweet{}} | {:deny, integer} | {:error, ExTwitter.Error}
  def destroy_favorite(tweet_id, user, options \\ []) do
    options = Keyword.merge(@defaults, options)

    with {:allow, _} <- check_rate_limit(user, options[:rate_limit]) do
      @twitter_client.destroy_favorite(tweet_id)
    end
  end

  @spec check_rate_limit(%User{}, integer) :: {:allow, integer} | {:deny, integer}
  defp check_rate_limit(user, rate_limit) do
    @rate_limiter.check("twitter:#{user.id}", @time_scale, rate_limit)
  end
end
