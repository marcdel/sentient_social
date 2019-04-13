defmodule SentientSocial.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SentientSocial.Accounts.{Credential, Token}

  schema "users" do
    field :name, :string
    field :username, :string
    has_one :credential, Credential
    has_one :token, Token

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  def token_changeset(user, token_attrs) do
    user
    |> changeset(%{token: token_attrs})
    |> cast_assoc(:token, with: &Token.changeset/2, required: true)
  end
end
