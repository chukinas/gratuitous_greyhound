defmodule Dreadnought.Players.MissionNameRegistry do

  use Agent
  use Dreadnought.Core.Mission.Spec

  @name __MODULE__
  @type player_uuid :: String.t

  # *** *******************************
  # *** AGENT

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  # *** *******************************
  # *** API

  @spec register(player_uuid, mission_spec) :: :ok | {:error, atom}
  def register(player_uuid, mission_spec) do
    if Agent.get(@name, &Map.has_key?(&1, player_uuid)) do
      {:error, :already_registered}
    else
      Agent.update(@name, &put_in(&1[player_uuid], mission_spec))
      :ok
    end
  end

  def get_all do
    Agent.get(@name, & &1)
  end

  @spec get(player_uuid) :: mission_spec | nil
  def get(player_uuid) do
    Agent.get(@name, &Map.get(&1, player_uuid))
  end

  @spec fetch(player_uuid) :: {:ok, mission_spec} | :error
  def fetch(player_uuid) do
    Agent.get(@name, &Map.fetch(&1, player_uuid))
  end

  @spec pop(player_uuid) :: mission_spec | nil
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
