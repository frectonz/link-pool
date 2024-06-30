defmodule LinkPool.PoolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LinkPool.Pools` context.
  """

  @doc """
  Generate a pool.
  """
  def pool_fixture(attrs \\ %{}) do
    {:ok, pool} =
      attrs
      |> Enum.into(%{
        description: "some description",
        public: true,
        title: "some title",
        views: 42
      })
      |> LinkPool.Pools.create_pool()

    pool
  end
end
