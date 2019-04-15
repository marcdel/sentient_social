defmodule TwitterClient do
  @moduledoc """
  Thin wrapper for the ExTwitter client
  """

  @behaviour ExTwitterBehavior

  def search(query, options \\ []), do: ExTwitter.search(query, options)
end
