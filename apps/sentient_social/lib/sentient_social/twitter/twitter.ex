defmodule SentientSocial.Twitter do
  @moduledoc """
  The Twitter context.
  """

  import Ecto.Query, warn: false
  alias SentientSocial.Repo

  alias ExTwitter.Config
  alias SentientSocial.Accounts
  alias SentientSocial.Accounts.User
  alias SentientSocial.Twitter.{AutomatedInteraction, RateLimitedTwitterClient}

  @doc """
  Retrieves the specified user's follower count and updates the users table

  ## Examples

      iex> update_twitter_followers("username")
      100

  """
  @spec update_twitter_followers(String.t()) :: {:ok, %User{}}
  def update_twitter_followers(username) do
    user =
      username
      |> Accounts.get_user_by_username()
      |> set_access_tokens()

    {:ok, twitter_user} = RateLimitedTwitterClient.user(user)

    {:ok, user} =
      Accounts.update_user(user, %{twitter_followers_count: twitter_user.followers_count})

    {:ok, _} = create_historical_follower_count(%{count: twitter_user.followers_count}, user)

    {:ok, user}
  end

  # Configure ExTwitter for the current process with the user's access tokens.
  # This allows the app to take actions on behalf of the user.
  @spec set_access_tokens(%User{} | nil) :: %User{}
  def set_access_tokens(nil), do: nil

  def set_access_tokens(user) do
    ExTwitter.configure(
      :process,
      Enum.concat(
        Config.get_tuples(),
        access_token: user.access_token,
        access_token_secret: user.access_token_secret
      )
    )

    user
  end

  @doc """
  Returns the list of automated_interactions for the user.

  ## Examples

      iex> list_automated_interactions(%User{})
      [%AutomatedInteraction{}, ...]

  """
  @spec list_automated_interactions(%User{}) :: list(%AutomatedInteraction{})
  def list_automated_interactions(user) do
    user
    |> Ecto.assoc(:automated_interactions)
    |> Repo.all()
  end

  @doc """
  Returns the latest automated_interactions for the user.

  ## Examples

      iex> latest_automated_interactions(%User{})
      [%AutomatedInteraction{}, ...]

  """
  @spec latest_automated_interactions(%User{}) :: list(%AutomatedInteraction{})
  def latest_automated_interactions(user) do
    user
    |> Ecto.assoc(:automated_interactions)
    |> order_by(desc: :inserted_at)
    |> limit(10)
    |> Repo.all()
  end

  @doc """
  Returns automated_interactions scheduled to be undone

  ## Examples

      iex> automated_interactions_to_be_undone(%User{})
      [%AutomatedInteraction{}, ...]

  """
  @spec automated_interactions_to_be_undone(%User{}) :: list(%AutomatedInteraction{})
  def automated_interactions_to_be_undone(user) do
    today = Date.utc_today()

    user
    |> Ecto.assoc(:automated_interactions)
    |> where([interaction], interaction.undo_at <= ^today and interaction.undone == false)
    |> Repo.all()
  end

  @doc """
  Gets a single automated_interaction.

  Raises `Ecto.NoResultsError` if the AutomatedInteraction does not exist.

  ## Examples

      iex> get_automated_interaction!(123, %User{})
      %AutomatedInteraction{}

      iex> get_automated_interaction!(456, %User{})
      ** (Ecto.NoResultsError)

  """
  @spec get_automated_interaction!(integer, %User{}) :: %AutomatedInteraction{}
  def get_automated_interaction!(id, user) do
    user
    |> Ecto.assoc(:automated_interactions)
    |> Repo.get!(id)
  end

  @doc """
  Creates a automated_interaction.

  ## Examples

      iex> create_automated_interaction(%{field: value}, %User{})
      {:ok, %AutomatedInteraction{}}

      iex> create_automated_interaction(%{field: bad_value}, %User{})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_automated_interaction(map, %User{}) ::
          {:ok, %AutomatedInteraction{}} | {:error, %Ecto.Changeset{}}
  def create_automated_interaction(attrs \\ %{}, user) do
    user
    |> Ecto.build_assoc(:automated_interactions)
    |> AutomatedInteraction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Marks an automated interaction as undone

  ## Examples

      iex> mark_interaction_undone(automated_interaction, user)
      {:ok, %AutomatedInteraction{}}

      iex> mark_interaction_undone(automated_interaction, user)
      {:error, %Ecto.Changeset{}}

  """
  @spec mark_interaction_undone(%AutomatedInteraction{}, %User{}) ::
          {:ok, %AutomatedInteraction{}} | {:error, %Ecto.Changeset{}}
  def mark_interaction_undone(automated_interaction, user) do
    user
    |> Ecto.build_assoc(:automated_interactions, automated_interaction)
    |> AutomatedInteraction.changeset(%{undone: true})
    |> Repo.update()
  end

  alias SentientSocial.Twitter.HistoricalFollowerCount

  @doc """
  Returns the list of historical_follower_counts.

  ## Examples

      iex> list_historical_follower_counts(%User{})
      [%HistoricalFollowerCount{}, ...]

  """
  @spec list_historical_follower_counts(%User{}) :: list(%HistoricalFollowerCount{})
  def list_historical_follower_counts(user) do
    user
    |> Ecto.assoc(:historical_follower_counts)
    |> Repo.all()
  end

  @doc """
  Returns the latest historical_follower_counts for the user.

  ## Examples

      iex> latest_historical_follower_counts(%User{})
      [%HistoricalFollowerCount{}, ...]

  """
  @spec latest_historical_follower_counts(%User{}) :: list(%HistoricalFollowerCount{})
  def latest_historical_follower_counts(user) do
    user
    |> Ecto.assoc(:historical_follower_counts)
    |> order_by(desc: :inserted_at)
    |> limit(20)
    |> Repo.all()
  end

  @doc """
  Gets a single historical_follower_count.

  Raises `Ecto.NoResultsError` if the Historical follower count does not exist.

  ## Examples

      iex> get_historical_follower_count!(123, %User{})
      %HistoricalFollowerCount{}

      iex> get_historical_follower_count!(456, %User{})
      ** (Ecto.NoResultsError)

  """
  @spec get_historical_follower_count!(integer, %User{}) :: %HistoricalFollowerCount{}
  def get_historical_follower_count!(id, user) do
    user
    |> Ecto.assoc(:historical_follower_counts)
    |> Repo.get!(id)
  end

  @doc """
  Creates a historical_follower_count.

  ## Examples

      iex> create_historical_follower_count(%{field: value}, %User{})
      {:ok, %HistoricalFollowerCount{}}

      iex> create_historical_follower_count(%{field: bad_value}, %User{})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_historical_follower_count(map, %User{}) ::
          {:ok, %HistoricalFollowerCount{}} | {:error, %Ecto.Changeset{}}
  def create_historical_follower_count(attrs \\ %{}, user) do
    user
    |> Ecto.build_assoc(:historical_follower_counts)
    |> HistoricalFollowerCount.changeset(attrs)
    |> Repo.insert()
  end
end
