defmodule Chukinas.Sessions.SessionSupervisor do

  alias Chukinas.Sessions.PlayerRooms
  alias Chukinas.Sessions.RoomDynamicSupervisor
  alias Chukinas.Sessions.RoomRegistry
  alias Chukinas.Sessions.PlayerRegistry
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      RoomRegistry,
      RoomDynamicSupervisor,
      PlayerRegistry,
      PlayerRooms,
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

end
