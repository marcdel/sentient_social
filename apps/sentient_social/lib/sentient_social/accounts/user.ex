defmodule SentientSocial.Accounts.User do
  @moduledoc """
  A sentient social user
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:profile_image_url, :string)
    field(:username, :string)

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map()) :: %Ecto.Changeset{}
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :name, :profile_image_url])
    |> validate_required([:username, :name, :profile_image_url])
  end
end
