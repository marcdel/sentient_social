defmodule SentientSocial.Boundary.FavoriteManager do
  use GenServer

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, initial_state(), Keyword.merge([name: __MODULE__], options))
  end

  @impl GenServer
  def init(state) do
    schedule_next()

    {:ok, state}
  end

  @impl GenServer
  def handle_info(:favorite, state) do
    {favorited_tweets, duration} =
      timed_function(fn -> SentientSocial.find_and_favorite_tweets() end)

    :telemetry.execute(
      [:sentient_social, :favorited_tweets],
      %{duration: duration, count: Enum.count(favorited_tweets)}
    )

    schedule_next()

    updated_tweets = Enum.take(favorited_tweets ++ state.favorited_tweets, 100)

    {:noreply, %{state | favorited_tweets: updated_tweets}}
  end

  defp schedule_next do
    Process.send_after(self(), :favorite, duration_in_minutes(1))
  end

  defp initial_state do
    %{favorited_tweets: []}
  end

  defp timed_function(function) do
    start_time = :erlang.monotonic_time(:milli_seconds)
    result = function.()
    duration = :erlang.monotonic_time(:milli_seconds) - start_time
    {result, duration}
  end

  defp duration_in_minutes(minutes) do
    minutes * 60 * 1000
  end
end
