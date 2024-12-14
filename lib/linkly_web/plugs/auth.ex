defmodule LinklyWeb.Plugs.Auth do
  import Plug.Conn
  use LinklyWeb, :controller
  alias LinklyWeb.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :token) do
      nil ->
        conn
        |> put_flash(:error, "Log in to continue")
        |> redirect(to: ~p"/login")
      token ->
        case Token.verify(token) do
          {:ok, data} ->
            case Map.get(data, :user_id) do
              nil ->
                conn
                |> put_flash(:error, "Log in to continue")
                |> redirect(to: ~p"/login")
              user_id ->
                assign(conn, :user_id, user_id)
            end

          _error ->
            conn
            |> put_flash(:error, "Log in to continue")
            |> redirect(to: ~p"/login")
        end
    end
  end
end
