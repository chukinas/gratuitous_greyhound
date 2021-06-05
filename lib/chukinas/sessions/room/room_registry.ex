alias Chukinas.Sessions.RoomRegistry

defmodule RoomRegistry do

  @me Registry.Rooms

  def child_spec(_init_arg) do
    Registry.child_spec(keys: :unique, name: @me)
  end

  def start_link(_init_arg) do
    Registry.start_link(keys: :unique, name: @me)
  end

  def build_name(room_name) do
    {:via, Registry, {@me, room_name}}
  end

end
