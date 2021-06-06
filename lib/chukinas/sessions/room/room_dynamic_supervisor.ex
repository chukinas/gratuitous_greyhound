alias Chukinas.Sessions.RoomDynamicSupervisor
alias Chukinas.Sessions.RoomServer

defmodule RoomDynamicSupervisor do
  use DynamicSupervisor

  @me :room_dynamic_supervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: @me)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def new_room(room_name) do
    child_spec = RoomServer.child_spec(room_name)
    DynamicSupervisor.start_child @me, child_spec
  end

  def print_children_info do
    DynamicSupervisor.which_children(@me)
  end

end
