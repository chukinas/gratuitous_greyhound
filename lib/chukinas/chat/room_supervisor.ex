defmodule Chukinas.Chat.Room.Supervisor do
  # Automatically defines child_spec/1
  use DynamicSupervisor
  alias Chukinas.Chat.Room

  @moduledoc """
  Supervises all chat rooms
  """

  #############################################################################
  # CLIENT API
  #############################################################################

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @spec start_room(String.t) :: {:ok, pid}
  def start_room(room_name) do
    child_spec = Room.child_spec(room_name)
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  #############################################################################
  # SERVER CALLBACKS
  #############################################################################

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
