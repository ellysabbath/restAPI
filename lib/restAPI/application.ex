defmodule RestAPI.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RestAPIWeb.Telemetry,
      RestAPI.Repo,
      {DNSCluster, query: Application.get_env(:restAPI, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: RestAPI.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: RestAPI.Finch},
      # Start a worker by calling: RestAPI.Worker.start_link(arg)
      # {RestAPI.Worker, arg},
      # Start to serve requests, typically the last entry
      RestAPIWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RestAPI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RestAPIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
