defmodule TweetFilterTest do
  use ExUnit.Case, async: true

  alias ExTwitter.Model.Tweet
  alias SentientSocial.Twitter.TweetFilter

  describe "filter/1" do
    test "removes tweets with more than the specified hashtags" do
      tweets = [
        %Tweet{id_str: "1", text: "hello #one #two #three #four"},
        %Tweet{id_str: "2", text: "#one #two hello #three #four #five"},
        %Tweet{id_str: "3", text: "#one #two #three #four #five #six hello"},
        %Tweet{id_str: "4", text: "hello"}
      ]

      assert tweets
             |> TweetFilter.filter()
             |> Enum.map(fn tweet -> tweet.id_str end) == ["1", "2", "4"]
    end

    test "removes tweets with only hashtags" do
      tweets = [
        %Tweet{id_str: "1", text: "hello #one #two #three #four"},
        %Tweet{id_str: "2", text: "#one #two #three #four"},
        %Tweet{id_str: "4", text: "hello"}
      ]

      assert tweets
             |> TweetFilter.filter()
             |> Enum.map(fn tweet -> tweet.id_str end) == ["1", "4"]
    end
  end
end
