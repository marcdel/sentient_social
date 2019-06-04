defmodule SentientSocial.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SentientSocial.Accounts.{Credential, SearchTerm, Token}

  schema "users" do
    has_one :credential, Credential
    has_many :search_terms, SearchTerm
    has_one :token, Token

    timestamps()
  end

  def username(%{token: nil} = user) do
    user.credential.email
  end

  def username(user) do
    user.token.username
  end

  def changeset(user, attrs) do
    cast(user, attrs, [])
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
