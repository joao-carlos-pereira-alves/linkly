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
    {:error, changeset}
  end

  # defp send_confirmation_email(user) do
  #   User.send_confirmation_email(user)
  # end
end
