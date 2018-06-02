defmodule SentientSocialWeb.TimeHelpersTest do
  use ExUnit.Case

  alias SentientSocialWeb.TimeHelpers

  describe "format/1" do
    test "formats NaiveDateTimes in 31/12/20018 13:04 format" do
      date_time = NaiveDateTime.from_iso8601!("2015-01-02 13:05:07")
      assert TimeHelpers.format(date_time) == "01/02/2015 13:05"
    end

    test "formats Dates in 31/12/20018 format" do
      date = Date.from_iso8601!("2015-01-23")
      assert TimeHelpers.format(date) == "01/23/2015"
    end
  end
end
