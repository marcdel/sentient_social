defmodule SentientSocial.Twitter.ExTwitterClient do
  @moduledoc """
  Wrapper for the ExTwitter client
  """

  @behaviour SentientSocial.Twitter.TwitterClient

  alias ExTwitter.Model.Tweet

  @doc """
  Search for tweets matching the specified string
  """
  @spec search(String.t(), count: integer) :: [%Tweet{}]
  def search(query, options \\ []), do: ExTwitter.search(query, options)

  @doc """
  Favorite the specified tweet by id
  Raises an ExTwitter.Error if the tweet has already been favorited
  """
  @spec create_favorite!(Integer) :: %Tweet{}
  def create_favorite!(tweet_id), do: ExTwitter.create_favorite(tweet_id, [])

  @doc """
  Favorite the specified tweet by id and return an :ok or an :error tuple
  """
  @spec create_favorite(Integer) :: {:ok, %Tweet{}} | {:error, String.t()}
  def create_favorite(tweet_id) do
    {:ok, ExTwitter.create_favorite(tweet_id, [])}
  rescue
    message in ExTwitter.Error ->
      {:error, message}
  end
end
