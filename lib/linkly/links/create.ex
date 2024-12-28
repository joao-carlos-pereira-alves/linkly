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

  defp handle_insert_result({:error, changeset}) do
    {:error, Ecto.Changeset.traverse_errors(changeset, &translate_errors/1)}
  end

  defp translate_errors({msg, opts}) do
    Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
      opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
    end)
  end
end
