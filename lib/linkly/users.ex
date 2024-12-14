defmodule Linkly.Users do
  alias Linkly.Users.Create
  # alias Linkly.Users.Delete
  alias Linkly.Users.Get
  # alias Linkly.Users.Update
  alias Linkly.Users.Verify

  defdelegate create(params), to: Create, as: :call
  # defdelegate delete(id), to: Delete, as: :call
  defdelegate get(id), to: Get, as: :call
  # defdelegate update(params), to: Update, as: :call
  defdelegate login(params), to: Verify, as: :call
  # defdelegate validation_account(params), to: Verify, as: :call
  # defdelegate resend_verification_account_code(params), to: Verify, as: :resend_verification_account_mailer
end
