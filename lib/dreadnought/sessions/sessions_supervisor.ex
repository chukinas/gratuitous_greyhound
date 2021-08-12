defmodule Dreadnought.Sessions.SessionSupervisor do

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      Dreadnought.Sessions.MissionBackup,
      Dreadnought.Sessions.MissionDynamicSupervisor,
      Dreadnought.Sessions.MissionRegistry,
      Dreadnought.Sessions.PlayerRegistry,
      Dreadnought.Sessions.PlayerRooms,
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

end
