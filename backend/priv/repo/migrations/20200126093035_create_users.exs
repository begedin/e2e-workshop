defmodule E2E.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string, null: false)
      add(:password, :string, null: false)

      timestamps()
    end

    create(unique_index(:users, :name))
  end
end
