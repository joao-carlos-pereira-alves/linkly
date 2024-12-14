defmodule Linkly.Users.Get do
  alias Linkly.Users.User
  alias Linkly.Repo

  def call(%{"email" => email}) do
    case get_by_email(email) do
      nil ->  { :error, %{ status: :not_found, message: "Usuário não encontrado" } }
      user -> { :ok, user}
    end
  end

  def call(id) do
    case Repo.get(User, id) do
      nil -> { :error, :not_found}
      user -> { :ok, user}
    end
  end

  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end
end
