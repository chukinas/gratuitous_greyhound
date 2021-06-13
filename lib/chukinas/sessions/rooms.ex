defmodule Chukinas.Sessions.Rooms do

  alias Chukinas.Sessions.RoomDynamicSupervisor
  alias Chukinas.Sessions.RoomRegistry

  # *** *******************************
  # *** API

  def add_member(room_name, member_uuid, member_name) when is_binary(room_name) do
    room_name
    |> get_room_pid
    |> GenServer.call({:add_member, member_uuid, member_name})
  end

  def remove_player(room_name, player_uuid) when is_binary(room_name) do
    room_name
    |> get_room_pid
    |> GenServer.call({:remove_player, player_uuid})
  end

  def get(room_name) when is_binary(room_name) do
    room_name
    |> get_room_pid
    |> GenServer.call(:get)
  end

  # *** *******************************
  # *** PRIVATE

  defp get_room_pid(room_name) when is_binary(room_name) do
    case RoomRegistry.pid(room_name) do
      nil ->
        {:ok, pid} = RoomDynamicSupervisor.new_room(room_name)
        pid
      pid ->
        pid
    end
  end

end
