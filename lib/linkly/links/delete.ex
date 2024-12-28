defmodule Linkly.Links.Delete do
  require Logger

  alias Linkly.Links.Link
  alias Linkly.Repo

  def call(id) do
    case Repo.get(Link, id) do
      nil -> { :error, :not_found}
      link -> Repo.delete(link)
    end
  end
end
