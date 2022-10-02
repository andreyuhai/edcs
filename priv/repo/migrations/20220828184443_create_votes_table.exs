defmodule Edcs.Repo.Migrations.CreateVotesTable do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add(:subject_id, references(:subjects))
      add(:user_id, references(:users))
    end
  end
end
