defmodule Chukinas.Sessions.PlayerRooms do

  use Agent

  @name __MODULE__
  @type player_uuid :: String.t
  @type room_name :: String.t

  # *** *******************************
  # *** AGENT

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  # *** *******************************
  # *** API

  def register(player_uuid, room_name) do
    if Agent.get(@name, &Map.has_key?(&1, player_uuid)) do
      {:error, :already_registered}
    else
      Agent.update(@name, &put_in(&1[player_uuid], room_name))
      :ok
    end
  end

  def get_all do
    Agent.get(@name, & &1)
  end

  @spec get(player_uuid) :: room_name | nil
  def get(player_uuid) do
    Agent.get(@name, &Map.get(&1, player_uuid))
  end

  @spec fetch(player_uuid) :: {:ok, room_name} | :error
  def fetch(player_uuid) do
    Agent.get(@name, &Map.fetch(&1, player_uuid))
    |> IOP.inspect("fetch, Players")
  end

  @spec pop(player_uuid) :: room_name | nil
  def pop(player_uuid) do
    Agent.get_and_update(@name, fn state ->
      Map.pop(state, player_uuid)
    end)
  end

  @spec delete(player_uuid) :: :ok
  def delete(player_uuid) do
    Agent.update(@name, &Map.delete(&1, player_uuid))
    :ok
  end

end
