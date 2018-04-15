defmodule SentientSocial.Twitter.TwitterClient do
  @moduledoc false

  @callback search(String.t(), count: integer) :: [%ExTwitter.Model.Tweet{}]
end
