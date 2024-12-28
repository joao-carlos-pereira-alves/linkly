defmodule Linkly.Links do
  alias Linkly.Links.Create
  alias Linkly.Links.Get
  alias Linkly.Links.Delete

  defdelegate create(params), to: Create, as: :call
  defdelegate list_links_by_user(user_id), to: Get, as: :list_links_by_user
  defdelegate call_by_shortened_url(shortened_url), to: Get, as: :call_by_shortened_url
  defdelegate get(id), to: Get, as: :call
  defdelegate delete(id), to: Delete, as: :call
end
