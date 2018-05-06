defmodule SentientSocial.Twitter.AutomatedInteraction do
  @moduledoc """
  An interaction (favorite, retweet, follow) created by the system on behalf of a user.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias SentientSocial.Accounts.User

  schema "automated_interactions" do
    field(:interaction_type, :string)
    field(:tweet_id, :integer)
    field(:tweet_text, :string)
    field(:tweet_url, :string)
    field(:tweet_user_description, :string)
    field(:tweet_user_screen_name, :string)
    field(:undo_at, :date)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map()) :: %Ecto.Changeset{}
  def changeset(automated_interaction, attrs) do
    automated_interaction
    |> cast(attrs, [
      :tweet_id,
      :tweet_text,
      :tweet_url,
      :tweet_user_screen_name,
      :tweet_user_description,
      :interaction_type,
      :undo_at
    ])
    |> validate_required([
      :tweet_user_screen_name,
      :interaction_type
    ])
    |> unique_constraint(:user_id_tweet_id_interaction_type)
  end
end
