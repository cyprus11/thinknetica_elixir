defmodule ManyToMany.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ManyToManyWeb.Telemetry,
      ManyToMany.Repo,
      {DNSCluster, query: Application.get_env(:many_to_many, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ManyToMany.PubSub},
      # Start a worker by calling: ManyToMany.Worker.start_link(arg)
      # {ManyToMany.Worker, arg},
      # Start to serve requests, typically the last entry
      ManyToManyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ManyToMany.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ManyToManyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
