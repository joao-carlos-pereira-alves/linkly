defmodule Linkly.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  @required_params_create [:title, :url, :user_id, :shortened_url, :access_count]

  schema "links" do
    field :title, :string
    field :url, :string
    field :shortened_url, :string
    field :access_count, :integer, default: 0

    belongs_to :user, Linkly.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(params) do
    shortened_url = generate_shortened_url()

    params =
      params
      |> Enum.into(%{}, fn {key, value} -> {to_string(key), value} end)
      |> Map.put("shortened_url", shortened_url)

    %__MODULE__{}
    |> cast(params, @required_params_create)
    |> do_validations(@required_params_create)
  end

  @doc """
  Retorna a URL completa combinando o base_url com o shortened_url.
  """
  def full_shortened_url(link) do
    base_url = Application.fetch_env!(:linkly, :base_url) # Configurado no `config.exs`
    "#{base_url}/in/#{link.shortened_url}"
  end

  defp do_validations(changeset, fields) do
    changeset
    |> validate_required(fields)
    |> assoc_constraint(:user)
    |> validate_length(:title, min: 3)
    |> validate_length(:title, max: 256)
    |> validate_format(:url, ~r/^(http|https):\/\/[^\s]+$/)
  end

  defp generate_shortened_url do
    :crypto.strong_rand_bytes(6)
    |> Base.url_encode64(padding: false)
    |> String.slice(0, 8) # Limite de 8 caracteres
  end
end
