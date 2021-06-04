alias Chukinas.Sessions.RoomDynamicSupervisor

defmodule RoomDynamicSupervisor do
  use DynamicSupervisor

  @me RoomDynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: @me)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

end
