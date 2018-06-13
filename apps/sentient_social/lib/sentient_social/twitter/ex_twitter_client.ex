defmodule SentientSocial.Twitter.ExTwitterClient do
  @moduledoc """
  Wrapper for the ExTwitter client
  """

  @behaviour SentientSocial.Twitter.TwitterClient

  alias ExTwitter.Model.User
  alias SentientSocial.Twitter.Tweet

  @doc """
  Search for tweets matching the specified string
  """
  @spec search(String.t(), count: integer, tweet_mode: String.t()) ::
          [%Tweet{}] | {:error, String.t()}

  def search(query, options \\ []) do
    query
    |> ExTwitter.search(options)
    |> Enum.map(&Tweet.new/1)
  rescue
    message in ExTwitter.Error ->
      {:error, message}
  end

  @doc """
  Get user information by id
  """
  @spec user(String.t() | Integer) :: {:ok, %User{}}
  def user(user), do: {:ok, ExTwitter.user(user)}

  @doc """
  Favorite the specified tweet by id and return an :ok or an :error tuple
  """
  @spec create_favorite(Integer) :: {:ok, %Tweet{}} | {:error, String.t()}
  def create_favorite(tweet_id) do
    {:ok,
     tweet_id
     |> ExTwitter.create_favorite([])
     |> Tweet.new()}
  rescue
    message in ExTwitter.Error ->
      {:error, message}
  end

  @doc """
  Unfavorite the specified tweet by id and return an :ok or an :error tuple
  """
  @spec destroy_favorite(Integer) :: {:ok, %Tweet{}} | {:error, String.t()}
  def destroy_favorite(tweet_id) do
    {:ok,
     tweet_id
     |> ExTwitter.destroy_favorite([])
     |> Tweet.new()}
  rescue
    message in ExTwitter.Error ->
      {:error, message}
  end
end
