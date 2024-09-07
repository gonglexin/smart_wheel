defmodule SmartWheel.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SmartWheelWeb.Telemetry,
      SmartWheel.Repo,
      {DNSCluster, query: Application.get_env(:smart_wheel, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SmartWheel.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SmartWheel.Finch},
      # Start a worker by calling: SmartWheel.Worker.start_link(arg)
      # {SmartWheel.Worker, arg},
      # Start to serve requests, typically the last entry
      SmartWheelWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SmartWheel.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SmartWheelWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
