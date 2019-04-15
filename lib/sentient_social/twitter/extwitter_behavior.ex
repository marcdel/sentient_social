defmodule ExTwitterBehavior do
  @callback search(String.t(), Keyword.t()) ::
              [ExTwitter.Model.Tweet.t()] | ExTwitter.Model.SearchResponse
end
