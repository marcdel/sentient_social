defmodule FindAndFavoriteTweetsTest do
  use ExUnit.Case, async: true

  @moduletag :integration

  test "calls twitter to search for and favorite tweets" do
    initial_state = %{favorited_tweets: []}

    {:noreply, state} =
      SentientSocial.Boundary.FavoriteManager.handle_info(:favorite, initial_state)

    assert Enum.count(state.favorited_tweets) > 0
  end
end
