defmodule LinkPoolWeb.PoolLiveTest do
  use LinkPoolWeb.ConnCase

  import Phoenix.LiveViewTest
  import LinkPool.PoolsFixtures

  @create_attrs %{public: true, description: "some description", title: "some title", views: 42}
  @update_attrs %{
    public: false,
    description: "some updated description",
    title: "some updated title",
    views: 43
  }
  @invalid_attrs %{public: false, description: nil, title: nil, views: nil}

  defp create_pool(_) do
    pool = pool_fixture()
    %{pool: pool}
  end

  describe "Index" do
    setup [:create_pool]

    test "lists all pools", %{conn: conn, pool: pool} do
      {:ok, _index_live, html} = live(conn, ~p"/pools")

      assert html =~ "Listing Pools"
      assert html =~ pool.description
    end

    test "saves new pool", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/pools")

      assert index_live |> element("a", "New Pool") |> render_click() =~
               "New Pool"

      assert_patch(index_live, ~p"/pools/new")

      assert index_live
             |> form("#pool-form", pool: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pool-form", pool: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pools")

      html = render(index_live)
      assert html =~ "Pool created successfully"
      assert html =~ "some description"
    end

    test "updates pool in listing", %{conn: conn, pool: pool} do
      {:ok, index_live, _html} = live(conn, ~p"/pools")

      assert index_live |> element("#pools-#{pool.id} a", "Edit") |> render_click() =~
               "Edit Pool"

      assert_patch(index_live, ~p"/pools/#{pool}/edit")

      assert index_live
             |> form("#pool-form", pool: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pool-form", pool: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pools")

      html = render(index_live)
      assert html =~ "Pool updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes pool in listing", %{conn: conn, pool: pool} do
      {:ok, index_live, _html} = live(conn, ~p"/pools")

      assert index_live |> element("#pools-#{pool.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pools-#{pool.id}")
    end
  end

  describe "Show" do
    setup [:create_pool]

    test "displays pool", %{conn: conn, pool: pool} do
      {:ok, _show_live, html} = live(conn, ~p"/pools/#{pool}")

      assert html =~ "Show Pool"
      assert html =~ pool.description
    end

    test "updates pool within modal", %{conn: conn, pool: pool} do
      {:ok, show_live, _html} = live(conn, ~p"/pools/#{pool}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Pool"

      assert_patch(show_live, ~p"/pools/#{pool}/show/edit")

      assert show_live
             |> form("#pool-form", pool: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#pool-form", pool: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/pools/#{pool}")

      html = render(show_live)
      assert html =~ "Pool updated successfully"
      assert html =~ "some updated description"
    end
  end
end
