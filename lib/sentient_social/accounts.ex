defmodule SentientSocial.Accounts do
  import Ecto.Query, warn: false

  alias SentientSocial.Accounts.User
  alias SentientSocial.Repo

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by_email(email) do
    query =
      from(
        u in User,
        join: c in assoc(u, :credential),
        where: c.email == ^email
      )

    query
    |> Repo.one()
    |> Repo.preload(:credential)
    |> Repo.preload(:token)
  end

  def authenticate_by_email_and_password(email, password) do
    user = get_user_by_email(email)

    cond do
      user && Pbkdf2.verify_pass(password, user.credential.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Bcrypt.no_user_verify()
        {:error, :not_found}
    end
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def register_user(attrs \\ %{}) do
    result =
      %User{}
      |> User.registration_changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, user} ->
        user =
          user
          |> Repo.preload(:credential)
          |> Repo.preload(:token)

        {:ok, user}

      error_result ->
        error_result
    end
  end

  def add_token(%User{} = user, attrs \\ %{}) do
    user
    |> Repo.preload(:token)
    |> User.token_changeset(attrs)
    |> Repo.update()
  end
end
