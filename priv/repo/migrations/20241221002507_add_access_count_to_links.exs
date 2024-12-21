defmodule Linkly.Repo.Migrations.AddAccessCountToLinks do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add :access_count, :integer, default: 0
    end
  end
end
