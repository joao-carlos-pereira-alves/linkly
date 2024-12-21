defmodule Linkly.Links.Create do
  require Logger

  alias Linkly.Links.Link
  alias Linkly.Repo

  def call(params) do
    params
    |> Link.changeset()
    |> Repo.insert()
    |> handle_insert_result()
  end

  defp handle_insert_result({:ok, link}) do
    {:ok, link}
  end
end
