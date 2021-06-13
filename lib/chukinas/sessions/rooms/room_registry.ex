alias Chukinas.Sessions.RoomRegistry

defmodule RoomRegistry do

  @me Registry.Rooms

  def child_spec(_init_arg) do
    Registry.child_spec(keys: :unique, name: @me)
  end

  def build_name(room_name) do
    {:via, Registry, {@me, room_name}}
  end

  def pid(room_name) do
    case Registry.lookup(@me, room_name) do
      [] -> nil
      [{pid, _value} | _tail] -> pid
    end
  end

end
