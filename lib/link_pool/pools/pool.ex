defmodule LinkPool.Pools.Pool do
  use Ecto.Schema
  import Ecto.Changeset
  alias LinkPool.Accounts.User
  alias LinkPool.Pools.Link

  schema "pools" do
    field :public, :boolean, default: false
    field :description, :string
    field :title, :string
    field :views, :integer, default: 0
    field :emoji, :string, default: "⚡️"
    belongs_to :user, User
    has_many :links, Link

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pool, attrs) do
    pool
    |> cast(attrs, [:title, :description, :views, :public, :emoji, :user_id])
    |> cast_assoc(:links, with: &Link.changeset/2)
    |> validate_required([:title, :description, :emoji, :user_id])
  end
end
