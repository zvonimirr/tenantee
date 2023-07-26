defmodule Tenantee.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Tenantee.Repo,
      # Start the Redix cache
      {Redix, {Application.get_env(:tenantee, :redis_connection_url), [name: :redix]}},
      # Start the Quantum cron scheduler
      Tenantee.Scheduler,
      # Start the PubSub system
      {Phoenix.PubSub, name: Tenantee.PubSub},
      # Start Finch
      {Finch, name: Tenantee.Finch},
      # Start the Endpoint (http/https)
      TenanteeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tenantee.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  # coveralls-ignore-start
  @impl true
  def config_change(changed, _new, removed) do
    TenanteeWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # coveralls-ignore-end
end
