defmodule LinklyWeb.Token do
  @moduledoc """
  Handles creating and validating tokens.
  """

  require Logger

  alias Phoenix.Token
  alias LinklyWeb.Endpoint

  @sign_salt "linkly_api"
  @period_in_seconds 1800

  def sign(user) do
    Token.sign(Endpoint, @sign_salt, %{user_id: user.id})
  end

  def verify(token) do
    case Token.verify(Endpoint, @sign_salt, token) do
      {:ok, _data} = result -> result
      {:error, _error} = error -> error
    end
  end

  def access_period_in_seconds do
    @period_in_seconds
  end
end
