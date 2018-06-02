defmodule SentientSocialWeb.TimeHelpers do
  @moduledoc """
  Helpers for DateTime display
  """

  @doc """
  """
  @spec format(nil | %Date{} | %NaiveDateTime{}) :: String.t()
  def format(nil), do: ""

  def format(%Date{} = date) do
    date
    |> (fn ^date -> Date.to_iso8601(date) <> " 00:00:00" end).()
    |> NaiveDateTime.from_iso8601!()
    |> format()
  end

  def format(%NaiveDateTime{} = date_time) do
    hour = date_time.hour |> Integer.to_string() |> String.pad_leading(2, "0")
    minute = date_time.minute |> Integer.to_string() |> String.pad_leading(2, "0")
    day = date_time.day |> Integer.to_string() |> String.pad_leading(2, "0")
    month = date_time.month |> Integer.to_string() |> String.pad_leading(2, "0")
    year = date_time.year

    do_format({hour, minute, day, month, year})
  end

  defp do_format({"00", "00", day, month, year}) do
    "#{month}/#{day}/#{year}"
  end

  defp do_format({hour, minute, day, month, year}) do
    "#{month}/#{day}/#{year} #{hour}:#{minute}"
  end
end
