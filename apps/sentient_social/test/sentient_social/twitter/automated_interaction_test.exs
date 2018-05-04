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
  end
end
