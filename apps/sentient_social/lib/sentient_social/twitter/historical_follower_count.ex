defmodule SentientSocial.Twitter.HistoricalFollowerCount do
  @moduledoc """
  A historical record of a user's twitter followers using the created_at timestamp
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias SentientSocial.Accounts.User

  schema "historical_follower_counts" do
    field(:count, :integer)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map()) :: %Ecto.Changeset{}
  def changeset(historical_follower_count, attrs) do
    historical_follower_count
    |> cast(attrs, [:count])
    |> validate_required([:count])
  end
end
