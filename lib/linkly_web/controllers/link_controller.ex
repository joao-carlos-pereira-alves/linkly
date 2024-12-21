defmodule LinklyWeb.LinkController do
  use LinklyWeb, :controller

  alias Linkly.Repo
  alias Linkly.Links

  action_fallback LinklyWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.assigns[:user_id]
    links = Links.list_links_by_user(user_id)
    render(conn, :links, layout: false, links: links)
  end

  def redirect_to_original(conn, %{"shortened_url" => shortened_url}) do
    case Linkly.Links.call_by_shortened_url(shortened_url) do
      nil ->
        conn
        |> put_flash(:error, "Link not found")
        |> redirect(to: "/")

      {:ok, link} ->
        link
        |> Ecto.Changeset.change(access_count: link.access_count + 1)
        |> Repo.update()

        redirect(conn, external: link.url)
    end
  end
end
