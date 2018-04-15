defmodule SentientSocial.Accounts.User do
  @moduledoc """
  A sentient social user
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias SentientSocial.Accounts.Keyword

  schema "users" do
    field(:name, :string)
    field(:profile_image_url, :string)
    field(:username, :string)
    has_many(:keywords, Keyword)

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map()) :: %Ecto.Changeset{}
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :name, :profile_image_url])
    |> validate_required([:username, :name, :profile_image_url])
    |> unique_constraint(:username)
  end
end
