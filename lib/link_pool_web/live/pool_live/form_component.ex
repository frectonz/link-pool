defmodule LinkPoolWeb.PoolLive.FormComponent do
  use LinkPoolWeb, :live_component

  alias LinkPool.Pools

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>A pool is a collection of links.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="pool-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:emoji]} type="emoji" label="Pool Emoji" />

        <:actions>
          <.button class="btn-accent" phx-disable-with="Saving...">Save Pool</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{pool: pool} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Pools.change_pool(pool))
     end)}
  end

  @impl true
  def handle_event("validate", %{"pool" => pool_params}, socket) do
    changeset = Pools.change_pool(socket.assigns.pool, pool_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"pool" => pool_params}, socket) do
    save_pool(socket, socket.assigns.action, pool_params)
  end

  defp save_pool(socket, :edit, pool_params) do
    case Pools.update_pool(socket.assigns.pool, pool_params) do
      {:ok, pool} ->
        notify_parent({:saved, pool})

        {:noreply,
         socket
         |> put_flash(:info, "Pool updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_pool(socket, :new, pool_params) do
    pool_params = pool_params |> Map.put("user_id", socket.assigns.user_id)

    case Pools.create_pool(pool_params) do
      {:ok, pool} ->
        notify_parent({:saved, pool})

        {:noreply,
         socket
         |> put_flash(:info, "Pool created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
