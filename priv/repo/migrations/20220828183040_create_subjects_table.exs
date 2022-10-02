defmodule Edcs.Repo.Migrations.CreateSubjectsTable do
  use Ecto.Migration

  def change do
    create table(:subjects) do
      add(:title, :string)

      timestamps()
    end
  end
end
