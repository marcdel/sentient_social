defmodule SentientSocial.Twitter.EngagementTest do
  use SentientSocial.DataCase, async: true
  import Mox
  import SentientSocial.Factory

  alias SentientSocial.Accounts.User
  alias SentientSocial.Twitter
  alias SentientSocial.Twitter.Engagement

  @twitter_client Application.get_env(:sentient_social, :twitter_client)

  setup :verify_on_exit!

  describe "favorite_new_keyword_tweets/1" do
    test "returns an empty list when no keywords found" do
      user = insert(:user, %{username: "testuser"})

      {:ok, tweets} = Engagement.favorite_new_keyword_tweets(user.username)
      assert tweets == []
    end

    test "finds and favorites tweets based on user keywords" do
      user = insert(:user, %{username: "testuser"})

      tweet1 = build(:ex_twitter_tweet, %{id: 1, text: "Tweet keyword1 text"})

      insert(:keyword, %{text: "keyword1", user: user})
      expect(@twitter_client, :search, 1, fn "keyword1", [count: _count] -> [tweet1] end)
      expect(@twitter_client, :create_favorite, 1, fn 1 -> {:ok, tweet1} end)

      tweet2 = build(:ex_twitter_tweet, %{id: 2, text: "Tweet keyword2 text"})

      insert(:keyword, %{text: "keyword2", user: user})
      expect(@twitter_client, :search, 1, fn "keyword2", [count: _count] -> [tweet2] end)
      expect(@twitter_client, :create_favorite, 1, fn 2 -> {:ok, tweet2} end)

      {:ok, tweets} = Engagement.favorite_new_keyword_tweets(user.username)

      assert Enum.count(tweets) == 2
      assert Enum.member?(tweets, tweet1)
      assert Enum.member?(tweets, tweet2)
    end

    test "saves favorited tweets as automated interactions" do
      user = insert(:user, %{username: "testuser"})

      tweet =
        build(:ex_twitter_tweet, %{
          id: 1,
          text: "Tweet keyword1 text",
          user: %{
            screen_name: "user",
            description: "description"
          }
        })

      insert(:keyword, %{text: "keyword1", user: user})
      expect(@twitter_client, :search, 1, fn "keyword1", [count: _count] -> [tweet] end)
      expect(@twitter_client, :create_favorite, 1, fn 1 -> {:ok, tweet} end)

      Engagement.favorite_new_keyword_tweets(user.username)

      automated_interactions = Twitter.list_automated_interactions(user)
      assert Enum.count(automated_interactions) == 1

      [automated_interaction] = automated_interactions
      assert automated_interaction.tweet_id == 1
      assert automated_interaction.tweet_text == "Tweet keyword1 text"
      assert automated_interaction.tweet_url == "https://twitter.com/statuses/1"
      assert automated_interaction.interaction_type == "favorite"
      assert automated_interaction.tweet_user_screen_name == "user"
      assert automated_interaction.tweet_user_description == "description"
    end

    test "handles retweets" do
      user = insert(:user, %{username: "testuser"})

      tweet =
        build(:ex_twitter_tweet, %{
          id: 1,
          retweeted_status: %{
            text: "Tweet keyword1 text",
            user: %{
              screen_name: "user",
              description: "description"
            }
          }
        })

      insert(:keyword, %{text: "keyword1", user: user})
      expect(@twitter_client, :search, 1, fn "keyword1", [count: _count] -> [tweet] end)
      expect(@twitter_client, :create_favorite, 1, fn 1 -> {:ok, tweet} end)

      {:ok, _} = Engagement.favorite_new_keyword_tweets(user.username)
      [automated_interaction] = Twitter.list_automated_interactions(user)

      assert automated_interaction.tweet_id == 1
      assert automated_interaction.tweet_text == "Tweet keyword1 text"
      assert automated_interaction.tweet_url == "https://twitter.com/statuses/1"
      assert automated_interaction.interaction_type == "favorite"
      assert automated_interaction.tweet_user_screen_name == "user"
      assert automated_interaction.tweet_user_description == "description"
    end

    test "does not return tweets that have already been favorited" do
      user = insert(:user)

      tweet = build(:ex_twitter_tweet, %{id: 1, text: "Tweet keyword1 text"})
      insert(:keyword, %{text: "keyword1", user: user})
      expect(@twitter_client, :search, 1, fn "keyword1", [count: _count] -> [tweet] end)

      expect(@twitter_client, :create_favorite, 1, fn 1 -> {:error, ""} end)

      {:ok, tweets} = Engagement.favorite_new_keyword_tweets(user.username)

      assert tweets == []
    end

    defmodule FakeTweetFilter do
      alias ExTwitter.Model.Tweet

      @spec filter(list(%Tweet{}), %User{}) :: []
      def filter(_tweets, _user) do
        []
      end
    end

    test "does not favorite filtered tweets" do
      user = insert(:user)

      tweet = build(:ex_twitter_tweet, %{id: 1, text: "Tweet keyword1 text"})
      insert(:keyword, %{text: "keyword1", user: user})
      expect(@twitter_client, :search, 1, fn "keyword1", [count: _count] -> [tweet] end)

      {:ok, tweets} = Engagement.favorite_new_keyword_tweets(user.username, FakeTweetFilter)

      assert tweets == []
    end
  end
end
