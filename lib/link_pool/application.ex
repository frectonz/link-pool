defmodule LinkPool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LinkPoolWeb.Telemetry,
      LinkPool.Repo,
      {DNSCluster, query: Application.get_env(:link_pool, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LinkPool.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LinkPool.Finch},
      # Start a worker by calling: LinkPool.Worker.start_link(arg)
      # {LinkPool.Worker, arg},
      # Start to serve requests, typically the last entry
      LinkPoolWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LinkPool.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LinkPoolWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
