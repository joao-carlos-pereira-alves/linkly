defmodule Linkly.Repo.Migrations.AddShortenedUrlToLinks do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add :shortened_url, :string
    end
  end
end
