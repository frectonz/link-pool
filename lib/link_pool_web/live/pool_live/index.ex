defmodule LinkPoolWeb.PoolLive.Index do
  alias LinkPool.Pools.Link
  use LinkPoolWeb, :live_view

  alias LinkPool.Pools
  alias LinkPool.Pools.Pool

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:user_id, socket.assigns.current_user.id)

    socket =
      case socket.assigns.live_action do
        :my ->
          socket
          |> assign(:page, :my)
          |> assign(:page_url, ~p"/pools/my")
          |> stream(:pools, Pools.my_pools(socket.assigns.current_user.id))

        _ ->
          socket
          |> assign(:page, :all)
          |> assign(:page_url, ~p"/pools")
          |> stream(:pools, Pools.list_pools())
      end

    {:ok, socket}
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
    |> assign(:back, if(socket.assigns.page == :my, do: ~p"/pools/my", else: ~p"/pools"))
    |> assign(:user_id, socket.assigns.current_user.id)
  end

  defp apply_action(socket, :my, _params) do
    socket
    |> assign(:page_title, "My Pools")
    |> assign(:pool, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Pools")
    |> assign(:pool, nil)
  end

  @impl true
  def handle_info({LinkPoolWeb.PoolLive.FormComponent, {:saved, pool}}, socket) do
    on_page = if pool.public, do: :all, else: :my

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
