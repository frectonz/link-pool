defmodule LinkPoolWeb.PoolLive.Show do
  use LinkPoolWeb, :live_view

  alias LinkPool.Pools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    pool = id |> Pools.get_pool!() |> Pools.inc_page_views()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pool, pool)}
  end

  defp page_title(:show), do: "Show Pool"
  defp page_title(:edit), do: "Edit Pool"
end
