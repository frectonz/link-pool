defmodule LinkPool.Pools do
  @moduledoc """
  The Pools context.
  """

  import Ecto.Query, warn: false
  alias LinkPool.Pools.Link
  alias LinkPool.Repo

  alias LinkPool.Pools.Pool

  @doc """
  Returns the list of pools.

  ## Examples

      iex> list_pools()
      [%Pool{}, ...]

  """
  def list_pools do
    Repo.all(from p in Pool, where: p.public) |> Repo.preload(:user)
  end

  @doc """
  Returns the list of pools created by a user.

  ## Examples

      iex> my_pools(user_id)
      [%Pool{}, ...]

  """
  def my_pools(user_id) do
    Repo.all(from p in Pool, where: p.user_id == ^user_id)
  end

  @doc """
  Gets a single pool.

  Raises `Ecto.NoResultsError` if the Pool does not exist.

  ## Examples

      iex> get_pool!(123)
      %Pool{}

      iex> get_pool!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pool!(id), do: Repo.get!(Pool, id)

  @doc """
  Creates a pool.

  ## Examples

      iex> create_pool(%{field: value})
      {:ok, %Pool{}}

      iex> create_pool(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pool(attrs \\ %{}) do
    %Pool{}
    |> Pool.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pool.

  ## Examples

      iex> update_pool(pool, %{field: new_value})
      {:ok, %Pool{}}

      iex> update_pool(pool, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pool(%Pool{} = pool, attrs) do
    pool
    |> Pool.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Incerment page views of a pool.

  ## Examples

      iex> inc_page_views(pool)
      {:ok, %Pool{}}

  """
  def inc_page_views(%Pool{} = pool) do
    {1, [%Pool{views: views}]} =
      from(p in Pool, where: p.id == ^pool.id, select: [:views])
      |> Repo.update_all(inc: [views: 1])

    put_in(pool.views, views)
  end

  @doc """
  Deletes a pool.

  ## Examples

      iex> delete_pool(pool)
      {:ok, %Pool{}}

      iex> delete_pool(pool)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pool(%Pool{} = pool) do
    Repo.delete(pool)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pool changes.

  ## Examples

      iex> change_pool(pool)
      %Ecto.Changeset{data: %Pool{}}

  """
  def change_pool(%Pool{} = pool, attrs \\ %{}) do
    changeset = Pool.changeset(pool, attrs)
    existing = Ecto.Changeset.get_assoc(changeset, :links)
    Ecto.Changeset.put_assoc(changeset, :links, existing ++ [%Link{}])
  end
end
