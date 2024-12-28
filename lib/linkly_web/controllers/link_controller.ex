defmodule LinklyWeb.LinkController do
  use LinklyWeb, :controller

  alias Linkly.Repo
  alias Linkly.Links

  action_fallback LinklyWeb.FallbackController

  def index(conn, _params) do
    user_id = conn.assigns[:user_id]
    links = Links.list_links_by_user(user_id)
    render(conn, :links, layout: false, links: links, changeset: %{}, page: 1, total_pages: 4)
  end

  def create(conn, params) do
    user_id = conn.assigns[:user_id]
    params = Map.put(params, "user_id", user_id)

    case Links.create(params) do
      {:ok, link} ->
        conn
        |> put_flash(:info, "Link added successfully")
        |> redirect(to: ~p"/home")

      {:error, %{links: ["has already been taken"]}} ->
        conn
        |> put_flash(:error, "A URL já foi associada a este usuário!")
        |> render(:links,
          layout: false,
          links: Links.list_links_by_user(user_id),
          changeset: %{}
        )

      {:error, %Ecto.Changeset{} = changeset} ->
        links = Links.list_links_by_user(user_id)

        conn
        |> put_flash(:error, "Unable to add link")
        |> render(:links, layout: false, links: links, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Links.delete(id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Link deleted successfully")
        |> redirect(to: ~p"/home")

      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Link not found")
        |> redirect(to: ~p"/home")
    end
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
