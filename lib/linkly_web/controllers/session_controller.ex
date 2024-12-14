defmodule LinklyWeb.SessionController do
  use LinklyWeb, :controller

  alias Linkly.Users
  alias LinklyWeb.Token
  alias Users.User

  action_fallback LinklyWeb.FallbackController

  def new(conn, _params) do
    render(conn, :session, layout: false, login: %{})
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Users.login(%{"email" => email, "password" => password}) do
      {:ok, %User{} = user} ->
        token = Token.sign(user)
        conn
        |> put_flash(:info, "Login successful!")
        |> put_session(:user_id, user.id)
        |> put_session(:token, token)
        |> redirect(to: ~p"/")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: ~p"/login")
    end
  end

  def login(conn, params) do
    with {:ok, %User{} = user} <- Users.login(params) do
      token = Token.sign(user)
      conn
      |> put_status(:ok)
      |> render(:login, token: token, user: user)
    end
  end
end
