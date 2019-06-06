defmodule SentientSocial.Accounts.SearchTerm do
  use Ecto.Schema
  import Ecto.Changeset
  alias SentientSocial.Accounts.User

  schema "search_terms" do
    field :text, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(search_term, attrs) do
    search_term
    |> cast(attrs, [:text, :user_id])
    |> validate_required([:text, :user_id])
    |> unique_constraint(:text, message: "already exists")
  end
end
