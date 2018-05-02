defmodule SentientSocial.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SentientSocial.Repo

  alias SentientSocial.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  @spec list_users() :: list(%User{})
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_user!(integer) :: %User{} | Ecto.NoResultsError
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.

  Returns nil if the User does not exist.

  ## Examples

      iex> get_user_by_username(123)
      %User{}

      iex> get_user_by_username(456)
      nil

  """
  @spec get_user_by_username(String) :: %User{} | nil
  def get_user_by_username(username), do: Repo.get_by(User, %{username: username})

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(map) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates or updates an existing user from auth payload

  ## Examples

    iex> create_or_update_from_twitter(%{screen_name: "user1"})
    {:ok, %User{}}

    iex> create_or_update_from_twitter(%{screen_name: "user2"})
    {:error, %Ecto.Changeset{}}

  """
  @spec create_or_update_from_twitter(%{
          screen_name: String,
          name: String,
          profile_image_url: String,
          access_token: String,
          access_token_secret: String
        }) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def create_or_update_from_twitter(%{screen_name: username} = attrs) do
    user_attrs = user_attrs_from_twitter(attrs)

    case get_user_by_username(username) do
      nil ->
        create_user(user_attrs)

      user ->
        update_user(user, user_attrs)
    end
  end

  defp user_attrs_from_twitter(%{
         screen_name: username,
         name: name,
         profile_image_url: profile_image_url,
         access_token: access_token,
         access_token_secret: access_token_secret
       }) do
    %{
      username: username,
      name: name,
      profile_image_url: profile_image_url,
      access_token: access_token,
      access_token_secret: access_token_secret
    }
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user(%User{}, map) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user(%User{}) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  @spec change_user(%User{}) :: %Ecto.Changeset{}
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias SentientSocial.Accounts.Keyword

  @doc """
  Returns the list of keywords for the user.

  ## Examples

      iex> list_keywords(%User{})
      [%Keyword{}, ...]

  """
  @spec list_keywords(%User{}) :: list(%Keyword{})
  def list_keywords(user) do
    user
    |> Ecto.assoc(:keywords)
    |> where([keyword], keyword.muted == false)
    |> Repo.all()

    # Repo.all(Keyword)
  end

  @doc """
  Returns the list of muted keywords for the user.

  ## Examples

      iex> list_muted_keywords(%User{})
      [%Keyword{}, ...]

  """
  @spec list_muted_keywords(%User{}) :: list(%Keyword{})
  def list_muted_keywords(user) do
    user
    |> Ecto.assoc(:keywords)
    |> where([keyword], keyword.muted == true)
    |> Repo.all()

    # Repo.all(Keyword)
  end

  @doc """
  Gets a single keyword.

  Raises `Ecto.NoResultsError` if the Keyword does not exist.

  ## Examples

      iex> get_keyword!(123, %User{})
      %Keyword{}

      iex> get_keyword!(456, %User{})
      ** (Ecto.NoResultsError)

  """
  @spec get_keyword!(integer, %User{}) :: %Keyword{}
  def get_keyword!(id, user) do
    user
    |> Ecto.assoc(:keywords)
    |> Repo.get!(id)
  end

  @doc """
  Gets a single keyword by its text.

  Raises `Ecto.NoResultsError` if the Keyword does not exist.

  ## Examples

      iex> find_keyword("something", %User{})
      %Keyword{}

      iex> find_keyword("something_else", %User{})
      nil

  """
  @spec find_keyword(String.t(), %User{}) :: %Keyword{}
  def find_keyword(text, user) do
    user
    |> Ecto.assoc(:keywords)
    |> Repo.get_by(text: text)
  end

  @doc """
  Creates a keyword.

  ## Examples

      iex> create_keyword(%{field: value}, %User{})
      {:ok, %Keyword{}}

      iex> create_keyword(%{field: bad_value}, %User{})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_keyword(map, %User{}) :: {:ok, %Keyword{}} | {:error, %Ecto.Changeset{}}
  def create_keyword(attrs \\ %{}, user) do
    user
    |> Ecto.build_assoc(:keywords)
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a muted keyword.

  ## Examples

      iex> create_muted_keyword(%{field: value}, %User{})
      {:ok, %Keyword{}}

      iex> create_muted_keyword(%{field: bad_value}, %User{})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_muted_keyword(map, %User{}) :: {:ok, %Keyword{}} | {:error, %Ecto.Changeset{}}
  def create_muted_keyword(attrs \\ %{}, user) do
    %{muted: true}
    |> Enum.into(attrs)
    |> create_keyword(user)
  end

  @doc """
  Deletes a Keyword.

  ## Examples

      iex> delete_keyword(keyword)
      {:ok, %Keyword{}}

      iex> delete_keyword(keyword)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_keyword(%Keyword{}) :: {:ok, %Keyword{}} | {:error, %Ecto.Changeset{}}
  def delete_keyword(%Keyword{} = keyword) do
    Repo.delete(keyword)
  end
end
