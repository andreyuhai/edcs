defmodule Edcs.Repo.Migrations.AddUniqueConstraintToUsernameOnUsers do
  use Ecto.Migration

  def change do
    create(index(:users, [:username], unique: true))
  end
end
