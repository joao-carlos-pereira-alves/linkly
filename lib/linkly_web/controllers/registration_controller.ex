defmodule LinklyWeb.RegistrationController do
  use LinklyWeb, :controller

  alias Linkly.Users
  alias LinklyWeb.Token
  alias Users.User

  action_fallback LinklyWeb.FallbackController

  def new(conn, _params) do
    render(conn, :signup, layout: false, signup: %{})
  end

  def signup(conn, params) do
    case Users.create(params) do
      {:ok, %User{} = user} ->
        token = Token.sign(user)

        conn
        |> put_flash(:info, "Account created successfully!")
        |> put_session(:user_id, user.id)
        |> put_session(:token, token)
        |> redirect(to: ~p"/home")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: ~p"/signup")
    end
  end
end
