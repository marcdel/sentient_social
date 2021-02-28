defmodule SentientSocial.Boundary.FavoriteManager do
  use GenServer
  use OpenTelemetryDecorator

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, initial_state(), Keyword.merge([name: __MODULE__], options))
  end

  @impl GenServer
  def init(state) do
    schedule_next()

    {:ok, state}
  end

  @impl GenServer
  @decorate trace("favorite_manager.favorite")
  def handle_info(:favorite, state) do
    favorited_tweets = SentientSocial.find_and_favorite_tweets(state.favorited_tweets)

    O11y.set_attributes(
      previously_favorited_tweets: Enum.count(state.favorited_tweets),
      favorited_tweets: Enum.count(favorited_tweets)
    )

    schedule_next()

    updated_tweets = Enum.take(favorited_tweets ++ state.favorited_tweets, 100)

    {:noreply, %{state | favorited_tweets: updated_tweets}}
  end

  defp schedule_next do
    Process.send_after(self(), :favorite, next_interval())
  end

  defp initial_state do
    %{favorited_tweets: []}
  end

  defp next_interval() do
    1..30
    |> Enum.random()
    |> :timer.minutes()
  end
end
