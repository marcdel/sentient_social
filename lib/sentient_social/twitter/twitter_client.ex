defmodule TwitterClient do
  @moduledoc """
  Thin wrapper for the ExTwitter client so we can mock/stub responses
  """

  @behaviour ExTwitterBehavior

  def search(query, options \\ []), do: ExTwitter.search(query, options)
  def show(tweet_id, options \\ []), do: ExTwitter.show(tweet_id, options)
  def create_favorite(tweet_id, options \\ []), do: ExTwitter.create_favorite(tweet_id, options)
  def configure(scope, options \\ []), do: ExTwitter.configure(scope, options)
  def get_tuples(), do: ExTwitter.Config.get_tuples()
end
