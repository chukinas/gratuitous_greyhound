defmodule Dreadnought.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Dreadnought.Players.Supervisor, []},
      {Dreadnought.Missions.Supervisor, []},
    ]
    opts = [strategy: :one_for_one, name: Dreadnought.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
