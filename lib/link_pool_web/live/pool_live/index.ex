defmodule LinkPoolWeb.PoolLive.Index do
  use LinkPoolWeb, :live_view

  alias LinkPool.Pools
  alias LinkPool.Pools.Pool

  @impl true
  def mount(params, _session, socket) do
    socket = assign(socket, :user_id, socket.assigns.current_user.id)

    if Map.has_key?(params, "my") do
      socket = assign(socket, :page, "my")
      {:ok, stream(socket, :pools, Pools.my_pools())}
    else
      socket = assign(socket, :page, "all")
      {:ok, stream(socket, :pools, Pools.list_pools())}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pool")
    |> assign(:pool, Pools.get_pool!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Pool")
    |> assign(:pool, %Pool{})
    |> assign(:user_id, socket.assigns.current_user.id)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Pools")
    |> assign(:pool, nil)
  end

  @impl true
  def handle_info({LinkPoolWeb.PoolLive.FormComponent, {:saved, pool}}, socket) do
    on_page = if pool.public, do: "all", else: "my"

    if on_page === socket.assigns.page do
      {:noreply, stream_insert(socket, :pools, pool)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pool = Pools.get_pool!(id)
    {:ok, _} = Pools.delete_pool(pool)

    {:noreply, stream_delete(socket, :pools, pool)}
  end
end
