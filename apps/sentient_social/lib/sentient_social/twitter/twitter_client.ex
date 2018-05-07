defmodule SentientSocial.Twitter.TwitterClient do
  @moduledoc false

  alias ExTwitter.Model.Tweet

  @callback search(String.t(), count: integer) :: [%Tweet{}]
  @callback create_favorite(Integer) :: {:ok, %Tweet{}} | {:error, String.t()}
  @callback destroy_favorite(Integer) :: {:ok, %Tweet{}} | {:error, String.t()}
end
