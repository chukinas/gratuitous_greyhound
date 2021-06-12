# TODO what's the right name / directory for this?
alias Chukinas.Sessions.{Players}

defmodule Players do
  use Agent

  @name __MODULE__
  #@table :players_table
  #defmodule Player do
  #  use TypedStruct
  #  typedstruct enforce: true do
  #    field :player_uuid, String.t
  #    field :room_name, String.t
  #  end
  #end

  # *** *******************************
  # *** CLIENT

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: @name)
    #:ets.new(@table, [:bag, :protected, :named_table])
    #GenServer.start_link(
    #  __MODULE__,
    #  opts,
    #  name: @name
    #)
  end

  def register(player_uuid, room_name) do
    if Agent.get(@name, &Map.has_key?(&1, player_uuid)) do
      {:error, :already_registered}
    else
      Agent.update(@name, &put_in(&1[player_uuid], room_name))
      :ok
    end
    #GenServer.call(@name, {:add, player_uuid, room_name})
  end

  def get_room(player_uuid) do
    case Agent.get(@name, & &1[player_uuid]) do
      nil -> {:error, :not_found}
      room_name -> {:ok, room_name}
    end
    #GenServer.call(@name, {:get_room, player_uuid})
    #fun = :ets.fun2ms(fn {room_name, _, player_uuid} when player_uuid == wanted_player_uuid -> room_name end)
    #case :ets.select(@table, fun) do
    #  [room_name] -> {:ok, room_name}
    #  [] -> {:error, "player not in a room"}
    #end
  end

  def remove(player_uuid) do
    Agent.get(@name, & &1[player_uuid])
    #with {:ok, room_name} <- get_player_room(player_uuid),
    #     player_id_uuid_tuples <- get_players_except(room_name, player_uuid),
    #     true <- :ets.delete(@table, room_name),
    #     :ok <- Enum.each(player_id_uuid_tuples, &add_player_tuple_to_room(&1, room_name)) do
    #end
  end

  # *** *******************************
  # *** PRIVATE

  #defp get_players_except(wanted_room_name, unwanted_player_uuid) do
  #  fun = :ets.fun2ms(fn {room_name, player_id, player_uuid} when room_name == wanted_room_name and player_uuid != unwanted_player_uuid -> {player_id, player_uuid} end)
  #  :ets.select(@table, fun)
  #end

  #defp add_player_tuple_to_room({player_id, player_uuid}, room_name) do
  #  insert(room_name, player_id, player_uuid)
  #end

  #defp insert(room_name, player_id, player_uuid) do
  #  :ets.insert(@table, {room_name, player_id, player_uuid})
  #end

end
