defmodule SentientSocial.Accounts.User do
  @moduledoc """
  A sentient social user
  """

  use Ecto.Schema
  import Ecto.Changeset
  require Logger
  alias SentientSocial.Accounts.Keyword
  alias SentientSocial.Twitter.{AutomatedInteraction, HistoricalFollowerCount}

  schema "users" do
    field(:name, :string)
    field(:profile_image_url, :string)
    field(:username, :string)
    field(:email, :string)
    field(:twitter_followers_count, :integer)
    field(:access_token, SentientSocial.Encrypted.Binary)
    field(:access_token_secret, SentientSocial.Encrypted.Binary)
    has_many(:automated_interactions, AutomatedInteraction)
    has_many(:keywords, Keyword)
    has_many(:historical_follower_counts, HistoricalFollowerCount)

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map()) :: %Ecto.Changeset{}
  def changeset(user, attrs) do
    Logger.info("attrs: #{inspect(attrs)}")

    user
    |> cast(attrs, [
      :username,
      :email,
      :name,
      :profile_image_url,
      :twitter_followers_count,
      :access_token,
      :access_token_secret
    ])
    |> unique_constraint(:username)
  end
end
