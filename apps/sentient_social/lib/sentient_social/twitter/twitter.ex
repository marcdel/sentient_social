defmodule SentientSocial.Twitter do
  @moduledoc """
  The Twitter context.
  """

  import Ecto.Query, warn: false
  alias SentientSocial.Repo

  alias SentientSocial.Accounts.User
  alias SentientSocial.Twitter.AutomatedInteraction

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
    |> where([interaction], interaction.undo_at == ^today)
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
end
