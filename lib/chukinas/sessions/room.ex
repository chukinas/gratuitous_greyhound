alias Chukinas.Sessions.{Room, RoomRegistry, RoomDynamicSupervisor}

defmodule Room do

  # *** *******************************
  # *** API

  def add_member(room_name, member_uuid, member_name) do
    room_name
    |> get_room_pid
    |> GenServer.call({:add_member, member_uuid, member_name})
  end

  # *** *******************************
  # *** PRIVATE

  defp get_room_pid(room_name) when is_binary(room_name) do
    case RoomRegistry.pid(room_name) do
      nil -> RoomDynamicSupervisor.new_room(room_name)
      pid -> pid
    end
  end

end
