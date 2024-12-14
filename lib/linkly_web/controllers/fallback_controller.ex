defmodule LinklyWeb.FallbackController do
  use LinklyWeb, :controller

  def call(conn, {:error, %{status: status, message: error_message}}) do
    conn
    |> put_status(status)
    |> put_view(json: LinklyWeb.ErrorJSON)
    |> render(:error, status: status, message: error_message)
  end

  def call(conn, { :error, :not_found }) do
    conn
    |> put_status(:not_found)
    |> put_view(json: LinklyWeb.ErrorJSON)
    |> render(:error, status: :not_found)
  end

  def call(conn, { :error, :bad_request }) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: LinklyWeb.ErrorJSON)
    |> render(:error, status: :bad_request)
  end

  def call(conn, { :error, %Ecto.Changeset{} = changeset }) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: LinklyWeb.ErrorJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, { :error, msg }) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: LinklyWeb.ErrorJSON)
    |> render(:error, msg: msg)
  end
end
