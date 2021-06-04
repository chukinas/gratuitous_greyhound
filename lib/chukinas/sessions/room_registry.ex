alias Chukinas.Sessions.RoomRegistry

defmodule RoomRegistry do

  def child_spec(_init_arg) do
    Registry.child_spec(keys: :unique, name: Registry.Rooms)
  end

  def start_link(_init_arg) do
    Registry.start_link(keys: :unique, name: Registry.Rooms)
  end

end
