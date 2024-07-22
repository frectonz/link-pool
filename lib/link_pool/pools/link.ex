defmodule LinkPool.Pools.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias LinkPool.Pools.Pool

  schema "pool_links" do
    field :title, :string
    field :url, :string
    field :icon, :string
    belongs_to :pool, Pool

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:title, :url, :icon])
    |> validate_required([:title, :url, :icon])
  end
end
