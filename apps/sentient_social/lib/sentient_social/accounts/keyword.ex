defmodule SentientSocial.Accounts.Keyword do
  @moduledoc """
  A keyword used to find posts and users to engage with
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias SentientSocial.Accounts.User

  schema "keywords" do
    field(:text, :string)
    field(:muted, :boolean)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map()) :: %Ecto.Changeset{}
  def changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:text, :muted])
    |> validate_required([:text])
    |> unique_constraint(:user_id_text)
  end
end
