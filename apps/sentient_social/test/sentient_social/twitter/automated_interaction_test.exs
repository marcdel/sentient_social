defmodule SentientSocial.AutomatedInteractionTest do
  use SentientSocial.DataCase, async: true

  import SentientSocial.Factory

  alias SentientSocial.Twitter
  alias SentientSocial.Twitter.AutomatedInteraction

  describe "automated_interactions" do
    test "list_automated_interactions/1 returns automated_interactions for user" do
      user = insert(:user)
      automated_interaction = insert(:automated_interaction, user: user)

      assert [^automated_interaction] =
               user
               |> Twitter.list_automated_interactions()
               |> Repo.preload(:user)
    end

    test "latest_automated_interactions/1 limits results to 10" do
      user = insert(:user)

      Enum.each(1..11, fn _ ->
        insert(:automated_interaction, user: user)
      end)

      assert user
             |> Twitter.latest_automated_interactions()
             |> Enum.count() == 10
    end

    test "latest_automated_interactions/1 orders by inserted_at time" do
      user = insert(:user)
      insert(:automated_interaction, id: 1, inserted_at: ~N[2000-01-03 00:00:00.00], user: user)
      insert(:automated_interaction, id: 2, inserted_at: ~N[2000-01-01 00:00:00.00], user: user)
      insert(:automated_interaction, id: 3, inserted_at: ~N[2000-01-02 00:00:00.00], user: user)

      assert user
             |> Twitter.latest_automated_interactions()
             |> Enum.map(fn x -> x.id end) == [1, 3, 2]
    end

    test "automated_interactions_to_be_undone/1 returns interactions with undo_at less than equal to today" do
      user = insert(:user)

      yesterday = Date.utc_today() |> Date.add(-1)
      tomorrow = Date.utc_today() |> Date.add(1)

      yesterdays_interaction = insert(:automated_interaction, undo_at: yesterday, user: user)
      todays_interaction = insert(:automated_interaction, undo_at: Date.utc_today(), user: user)
      tomorrows_interaction = insert(:automated_interaction, undo_at: tomorrow, user: user)

      interaction_ids =
        user
        |> Twitter.automated_interactions_to_be_undone()
        |> Enum.map(fn x -> x.id end)

      assert Enum.member?(interaction_ids, yesterdays_interaction.id)
      assert Enum.member?(interaction_ids, todays_interaction.id)
      refute Enum.member?(interaction_ids, tomorrows_interaction.id)
    end

    test "automated_interactions_to_be_undone/1 does not return interactions that are undone" do
      user = insert(:user)

      interaction = insert(:automated_interaction, undo_at: Date.utc_today(), user: user)

      undone_interaction =
        insert(:automated_interaction, undo_at: Date.utc_today(), undone: true, user: user)

      interaction_ids =
        user
        |> Twitter.automated_interactions_to_be_undone()
        |> Enum.map(& &1.id)

      assert Enum.member?(interaction_ids, interaction.id)
      refute Enum.member?(interaction_ids, undone_interaction.id)
    end

    test "get_automated_interactions!/2 returns the automated_interaction with given id" do
      user = insert(:user)
      automated_interaction = insert(:automated_interaction, user: user)

      assert automated_interaction.id
             |> Twitter.get_automated_interaction!(user)
             |> Repo.preload(:user) == automated_interaction
    end

    test "get_automated_interaction!/2 returns an error if it doesn't belong to the user" do
      automated_interaction = insert(:automated_interaction)
      another_user = build(:user, %{username: "another_user"})

      assert_raise Ecto.NoResultsError, fn ->
        Twitter.get_automated_interaction!(automated_interaction.id, another_user)
      end
    end

    test "create_automated_interaction/2 with valid data creates a automated_interaction" do
      user = insert(:user)

      new_automated_interaction =
        params_for(:automated_interaction, %{tweet_text: "some text", user: user})

      assert {:ok, %AutomatedInteraction{} = automated_interaction} =
               Twitter.create_automated_interaction(new_automated_interaction, user)

      assert automated_interaction.tweet_text == "some text"
    end

    test "create_automated_interaction/2 returns an error if automated_interaction exists" do
      user1 = insert(:user, %{username: "user1"})
      user2 = insert(:user, %{username: "user2"})

      new_automated_interaction = params_for(:automated_interaction, %{tweet_id: 1})

      assert {:ok, %AutomatedInteraction{} = automated_interaction} =
               Twitter.create_automated_interaction(new_automated_interaction, user1)

      assert {:error, %Ecto.Changeset{}} =
               Twitter.create_automated_interaction(new_automated_interaction, user1)

      assert {:ok, %AutomatedInteraction{} = automated_interaction} =
               Twitter.create_automated_interaction(new_automated_interaction, user2)
    end

    test "create_automated_interaction/2 with invalid data returns error changeset" do
      user = insert(:user)

      new_automated_interaction =
        params_for(:automated_interaction, %{tweet_user_screen_name: nil})

      assert {:error, %Ecto.Changeset{}} =
               Twitter.create_automated_interaction(new_automated_interaction, user)
    end

    test "mark_interaction_undone/1 marks the interaction as undone" do
      user = insert(:user)

      new_automated_interaction = insert(:automated_interaction)

      assert new_automated_interaction.undone == false

      {:ok, %AutomatedInteraction{} = automated_interaction} =
        Twitter.mark_interaction_undone(new_automated_interaction, user)

      assert automated_interaction.undone == true
    end
  end
end
