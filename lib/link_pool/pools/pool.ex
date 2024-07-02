defmodule LinkPool.Pools.Pool do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pools" do
    field :public, :boolean, default: false
    field :description, :string
    field :title, :string
    field :views, :integer, default: 0
    field :emoji, :string, default: "⚡️"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pool, attrs) do
    pool
    |> cast(attrs, [:title, :description, :views, :public, :emoji])
    |> validate_required([:title, :description, :emoji])
  end
end
