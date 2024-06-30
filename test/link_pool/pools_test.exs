defmodule LinkPool.PoolsTest do
  use LinkPool.DataCase

  alias LinkPool.Pools

  describe "pools" do
    alias LinkPool.Pools.Pool

    import LinkPool.PoolsFixtures

    @invalid_attrs %{public: nil, description: nil, title: nil, views: nil}

    test "list_pools/0 returns all pools" do
      pool = pool_fixture()
      assert Pools.list_pools() == [pool]
    end

    test "get_pool!/1 returns the pool with given id" do
      pool = pool_fixture()
      assert Pools.get_pool!(pool.id) == pool
    end

    test "create_pool/1 with valid data creates a pool" do
      valid_attrs = %{
        public: true,
        description: "some description",
        title: "some title",
        views: 42
      }

      assert {:ok, %Pool{} = pool} = Pools.create_pool(valid_attrs)
      assert pool.public == true
      assert pool.description == "some description"
      assert pool.title == "some title"
      assert pool.views == 42
    end

    test "create_pool/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pools.create_pool(@invalid_attrs)
    end

    test "update_pool/2 with valid data updates the pool" do
      pool = pool_fixture()

      update_attrs = %{
        public: false,
        description: "some updated description",
        title: "some updated title",
        views: 43
      }

      assert {:ok, %Pool{} = pool} = Pools.update_pool(pool, update_attrs)
      assert pool.public == false
      assert pool.description == "some updated description"
      assert pool.title == "some updated title"
      assert pool.views == 43
    end

    test "update_pool/2 with invalid data returns error changeset" do
      pool = pool_fixture()
      assert {:error, %Ecto.Changeset{}} = Pools.update_pool(pool, @invalid_attrs)
      assert pool == Pools.get_pool!(pool.id)
    end

    test "delete_pool/1 deletes the pool" do
      pool = pool_fixture()
      assert {:ok, %Pool{}} = Pools.delete_pool(pool)
      assert_raise Ecto.NoResultsError, fn -> Pools.get_pool!(pool.id) end
    end

    test "change_pool/1 returns a pool changeset" do
      pool = pool_fixture()
      assert %Ecto.Changeset{} = Pools.change_pool(pool)
    end
  end
end
