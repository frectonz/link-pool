defmodule LinkPool.Repo.Migrations.CreatePoolLinks do
  use Ecto.Migration

  def change do
    create table(:pool_links) do
      add :title, :string
      add :url, :string
      add :icon, :string
      add :pool_id, references(:pools, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:pool_links, [:pool_id])
  end
end
