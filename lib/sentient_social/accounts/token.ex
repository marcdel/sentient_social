defmodule EncryptedBinary do
  use Cloak.Fields.Binary, vault: SentientSocial.Vault
end

defmodule SentientSocial.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias SentientSocial.Accounts.User

  schema "tokens" do
    field :token, EncryptedBinary
    field :token_secret, EncryptedBinary
    field :provider, :string
    field :username, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:provider, :username, :token, :token_secret, :user_id])
    |> validate_required([:provider, :username, :token, :token_secret, :user_id])
  end
end
