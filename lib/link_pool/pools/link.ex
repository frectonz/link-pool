defmodule LinkPool.Pools.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias LinkPool.Pools.Pool

  schema "pool_links" do
    field :title, :string
    field :url, :string
    field :icon, :string
    belongs_to :pool, Pool

    field(:delete, :boolean, virtual: true)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    changeset =
      link
      |> cast(attrs, [:title, :url, :icon])
      |> validate_required([:title, :url, :icon])

    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
