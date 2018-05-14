defmodule SentientSocial.HistoricalFollowerCountTest do
  use SentientSocial.DataCase, async: true

  import SentientSocial.Factory

  alias SentientSocial.Twitter
  alias SentientSocial.Twitter.HistoricalFollowerCount

  describe "historical_follower_counts" do
    test "list_historical_follower_counts/1 returns all historical_follower_counts" do
      user = insert(:user)
      historical_follower_count = insert(:historical_follower_count, %{user: user})

      assert user
             |> Twitter.list_historical_follower_counts()
             |> Repo.preload(:user) == [historical_follower_count]
    end

    test "get_historical_follower_count!/1 returns the historical_follower_count with given id" do
      user = insert(:user)
      historical_follower_count = insert(:historical_follower_count, %{user: user})

      assert historical_follower_count.id
             |> Twitter.get_historical_follower_count!(user)
             |> Repo.preload(:user) == historical_follower_count
    end

    test "create_historical_follower_count/1 with valid data creates a historical_follower_count" do
      user = insert(:user)

      assert {:ok, %HistoricalFollowerCount{} = historical_follower_count} =
               Twitter.create_historical_follower_count(%{count: 100}, user)

      assert historical_follower_count.count == 100
    end

    test "create_historical_follower_count/1 with invalid data returns error changeset" do
      user = insert(:user)

      assert {:error, %Ecto.Changeset{}} =
               Twitter.create_historical_follower_count(%{count: nil}, user)
    end
  end
end
