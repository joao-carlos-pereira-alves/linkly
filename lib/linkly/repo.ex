defmodule Linkly.Repo do
  use Ecto.Repo,
    otp_app: :linkly,
    adapter: Ecto.Adapters.Postgres
end
