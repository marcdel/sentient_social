defmodule TweetFilterTest do
  use SentientSocial.DataCase, async: true

  import SentientSocial.Factory

  alias ExTwitter.Model.Tweet
  alias SentientSocial.Twitter.TweetFilter

  describe "filter/1" do
    test "removes tweets with more than the specified hashtags" do
      user = insert(:user)

      tweets = [
        %Tweet{id_str: "1", text: "hello #one #two #three #four"},
        %Tweet{id_str: "2", text: "#one #two hello #three #four #five"},
        %Tweet{id_str: "3", text: "#one #two #three #four #five #six hello"},
        %Tweet{id_str: "4", text: "hello"}
      ]

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.map(fn tweet -> tweet.id_str end) == ["1", "2", "4"]
    end

    test "removes tweets with only hashtags" do
      user = insert(:user)

      tweets = [
        %Tweet{id_str: "1", text: "hello #one #two #three #four"},
        %Tweet{id_str: "2", text: "#one #two #three #four"},
        %Tweet{id_str: "4", text: "hello"}
      ]

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.map(fn tweet -> tweet.id_str end) == ["1", "4"]
    end

    test "removes tweets containing muted keywords" do
      user = insert(:user)
      insert(:muted_keyword, %{text: "#spam", user: user})

      tweets = [
        %Tweet{id_str: "1", text: "hello"},
        %Tweet{id_str: "2", text: "hello #spam"}
      ]

      assert tweets
             |> TweetFilter.filter(user)
             |> Enum.map(fn tweet -> tweet.id_str end) == ["1"]
    end
  end
end
