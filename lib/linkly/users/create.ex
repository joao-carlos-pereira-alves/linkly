defmodule Linkly.Users.Create do
  require Logger

  alias Linkly.Users.User
  alias Linkly.Repo

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
    |> handle_insert_result()
  end

  defp handle_insert_result({:ok, user}) do
    # send_confirmation_email(user)
    {:ok, user}
  end

  defp handle_insert_result({:error, changeset}) do
    case get_unique_email_error(changeset) do
      true ->
        {:error, %{ status: :unprocessable_entity, message: "O e-mail já está em uso." }}
      false ->
        {:error, changeset}
    end
  end

  # defp send_confirmation_email(user) do
  #   User.send_confirmation_email(user)
  # end

  defp get_unique_email_error(changeset) do
    errors = Tuple.to_list(changeset.errors[:email])
    "has already been taken" in errors
  end
end
