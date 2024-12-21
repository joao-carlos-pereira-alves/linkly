defmodule Linkly.Links.Delete do
  require Logger

  alias Linkly.Links.Link
  alias Linkly.Repo

  def call(params) do
    params
    |> Link.changeset()
    |> Repo.insert()
  end
end
