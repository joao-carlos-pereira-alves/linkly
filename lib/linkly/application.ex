defmodule Linkly.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LinklyWeb.Telemetry,
      Linkly.Repo,
      {DNSCluster, query: Application.get_env(:linkly, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Linkly.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Linkly.Finch},
      # Start a worker by calling: Linkly.Worker.start_link(arg)
      # {Linkly.Worker, arg},
      # Start to serve requests, typically the last entry
      LinklyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Linkly.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LinklyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
