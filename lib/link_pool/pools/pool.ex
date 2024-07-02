defmodule LinkPool.Pools.Pool do
  use Ecto.Schema
  import Ecto.Changeset
  alias LinkPool.Accounts.User

  schema "pools" do
    field :public, :boolean, default: false
    field :description, :string
    field :title, :string
    field :views, :integer, default: 0
    field :emoji, :string, default: "⚡️"
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pool, attrs) do
    pool
    |> cast(attrs, [:title, :description, :views, :public, :emoji, :user_id])
    |> validate_required([:title, :description, :emoji, :user_id])
  end
end
