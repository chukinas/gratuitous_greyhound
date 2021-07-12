defmodule Chukinas.Sessions.Rooms do

  alias Chukinas.Sessions.Room
  alias Chukinas.Sessions.RoomDynamicSupervisor
  alias Chukinas.Sessions.RoomJoin
  alias Chukinas.Sessions.RoomRegistry

  # *** *******************************
  # *** GETTERS

  def room_name(%RoomJoin{room_name: value}), do: value

  def room_name(%Room{name: value}), do: value

  # *** *******************************
  # *** API

  @spec add_player(RoomJoin.t) :: atom
  def add_player(%RoomJoin{} = room_join) do
    genserver_call room_join.room_name, {:add_player, room_join}
  end

  def drop_player(room_name, player_uuid) when is_binary(room_name) do
    genserver_call room_name, {:drop_player, player_uuid}
  end

  def get(room_name) when is_binary(room_name) do
    genserver_call room_name, :get
  end

  def fetch(room_name) do
    case get(room_name) do
      nil -> :error
      room -> {:ok, room}
    end
  end

  def toggle_ready(room_name, player_id) when is_integer(player_id) do
    genserver_cast room_name, {:toggle_ready, player_id}
  end

  def update_mission(room_name, fun) do
    genserver_cast room_name, {:update_mission, fun}
  end

  # *** *******************************
  # *** PRIVATE

  defp genserver_call(room_name, msg) do
    room_name
    |> room_pid_from_name
    |> GenServer.call(msg)
  end

  defp genserver_cast(room_name, msg) do
    room_name
    |> room_pid_from_name
    |> GenServer.cast(msg)
  end

  defp room_pid_from_name(room_name) when is_binary(room_name) do
    with :error <- RoomRegistry.fetch_pid(room_name),
         {:ok, pid} <- RoomDynamicSupervisor.new_room(room_name) do
      pid
    else
      {:ok, pid} -> pid
    end
  end

end
