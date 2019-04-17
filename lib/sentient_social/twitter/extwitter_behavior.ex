defmodule ExTwitterBehavior do
  @callback search(String.t(), Keyword.t()) ::
              [ExTwitter.Model.Tweet.t()] | ExTwitter.Model.SearchResponse

  @callback create_favorite(Integer, Keyword.t()) :: ExTwitter.Model.Tweet.t()

  @callback configure(:global | :process, Keyword.t()) :: :ok

  @callback get_tuples() :: []
end
