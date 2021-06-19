alias Chukinas.Sessions.RoomDynamicSupervisor
alias Chukinas.Sessions.RoomServer

defmodule RoomDynamicSupervisor do
  use DynamicSupervisor

  # *** *******************************
  # *** CONSTRUCTORS

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  # *** *******************************
  # *** CALLBACKS

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # *** *******************************
  # *** API

  @spec new_room(String.t) :: {:ok, pid}
  def new_room(room_name) do
    child_spec = RoomServer.child_spec(room_name)
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def print_children_info do
    DynamicSupervisor.which_children(__MODULE__)
  end

end
