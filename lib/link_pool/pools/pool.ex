defmodule LinkPool.Pools.Pool do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pools" do
    field :public, :boolean, default: false
    field :description, :string
    field :title, :string
    field :views, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pool, attrs) do
    pool
    |> cast(attrs, [:title, :description, :views, :public])
    |> validate_required([:title, :description, :views, :public])
  end
end
