defmodule Et.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EtWeb.Telemetry,
      Et.Repo,
      {DNSCluster, query: Application.get_env(:exam_tender, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Et.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Et.Finch},
      # Start a worker by calling: Et.Worker.start_link(arg)
      # {Et.Worker, arg},
      # Start to serve requests, typically the last entry
      EtWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Et.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EtWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
