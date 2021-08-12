defmodule Dreadnought.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  alias Dreadnought.Sessions.SessionSupervisor
  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DreadnoughtWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dreadnought.PubSub},
      # Start the Endpoint (http/https)
      DreadnoughtWeb.Endpoint,
      {SessionSupervisor, []},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dreadnought.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DreadnoughtWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
