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

    test "latest_historical_follower_counts/1 limits results to 20" do
      user = insert(:user)

      Enum.each(1..21, fn _ ->
        insert(:historical_follower_count, user: user)
      end)

      assert user
             |> Twitter.latest_historical_follower_counts()
             |> Enum.count() == 20
    end

    test "latest_historical_follower_counts/1 orders by inserted_at time" do
      user = insert(:user)

      insert(
        :historical_follower_count,
        id: 1,
        inserted_at: ~N[2000-01-03 00:00:00.00],
        user: user
      )

      insert(
        :historical_follower_count,
        id: 2,
        inserted_at: ~N[2000-01-01 00:00:00.00],
        user: user
      )

      insert(
        :historical_follower_count,
        id: 3,
        inserted_at: ~N[2000-01-02 00:00:00.00],
        user: user
      )

      assert user
             |> Twitter.latest_historical_follower_counts()
             |> Enum.map(fn x -> x.id end) == [1, 3, 2]
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
