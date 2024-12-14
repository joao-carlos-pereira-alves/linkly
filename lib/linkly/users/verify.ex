defmodule Linkly.Users.Verify do
  alias Linkly.Users
  # alias Linkly.Users.User
  # alias LinklyWeb.Token

  def call(%{"email" => email, "password" => password}) do
    case Users.get(%{"email" => email}) do
      {:ok, user} -> verify(user, password)
      {:error, _} = error -> error
    end
  end

  defp verify(user, password) do
    case Argon2.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, %{ status: :unauthorized, message: "Senha incorreta" }}
    end
  end
end
