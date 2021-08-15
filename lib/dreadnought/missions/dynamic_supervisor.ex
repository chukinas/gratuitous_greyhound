defmodule Dreadnought.Missions.DynamicSupervisor do

  use DynamicSupervisor
  alias Dreadnought.Missions.Server, as: MissionServer

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

  @spec new_mission(String.t) :: {:ok, pid}
  def new_mission(mission_name) do
    child_spec = MissionServer.child_spec(mission_name)
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def print_children_info do
    DynamicSupervisor.which_children(__MODULE__)
  end

end
