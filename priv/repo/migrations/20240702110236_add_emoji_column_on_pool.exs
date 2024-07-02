defmodule LinkPool.Repo.Migrations.AddEmojiColumnOnPool do
  use Ecto.Migration

  def change do
    alter table(:pools) do
      add :emoji, :string
    end
  end
end
