defmodule SentientSocial.Twitter.ExTwitterClient do
  @moduledoc """
  Wrapper for the ExTwitter client
  """

  @behaviour SentientSocial.Twitter.TwitterClient

  @doc """
  Search for tweets matching the specified string
  """
  @spec search(String.t(), count: integer) :: [%ExTwitter.Model.Tweet{}]
  def search(query, options \\ []), do: ExTwitter.search(query, options)
end
