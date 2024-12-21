defmodule Linkly.Links.Get do
  alias Linkly.Repo
  alias Linkly.Links.Link

  import Ecto.Query, only: [from: 2]

  def call(id) do
    case Repo.get(Link, id) do
      nil -> { :error, :not_found}
      link -> { :ok, link}
    end
  end

  def call_by_shortened_url(shortened_url) do
    case Repo.get_by(Link, shortened_url: shortened_url) do
      nil ->
        {:error, :not_found}

      link ->
        {:ok, link}
    end
  end

  def list_links_by_user(user_id) do
    Repo.all(from l in Link, where: l.user_id == ^user_id, order_by: [desc: l.inserted_at])
  end
end
