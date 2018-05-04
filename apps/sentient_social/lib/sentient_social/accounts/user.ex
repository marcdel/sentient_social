defmodule SentientSocial.Accounts.User do
  @moduledoc """
  A sentient social user
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias SentientSocial.Accounts.Keyword
  alias SentientSocial.Twitter.AutomatedInteraction

  schema "users" do
    field(:name, :string)
    field(:profile_image_url, :string)
    field(:username, :string)
    field(:access_token, Cloak.EncryptedBinaryField)
    field(:access_token_secret, Cloak.EncryptedBinaryField)
    has_many(:automated_interactions, AutomatedInteraction)
    has_many(:keywords, Keyword)

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map()) :: %Ecto.Changeset{}
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :name, :profile_image_url, :access_token, :access_token_secret])
    |> validate_required([
      :username,
      :name,
      :profile_image_url,
      :access_token,
      :access_token_secret
    ])
    |> unique_constraint(:username)
  end
end
