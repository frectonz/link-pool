defmodule LinkPool.Repo.Migrations.CreatePools do
  use Ecto.Migration

  def change do
    create table(:pools) do
      add :title, :string
      add :description, :string
      add :views, :integer
      add :public, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
