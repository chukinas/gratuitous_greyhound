# TODO rename Dreadnought.Play ?
defmodule Dreadnought.Sessions do

  @moduledoc """
  The Sessions context
  """

  alias Dreadnought.Core.ActionSelection
  alias Dreadnought.Core.Mission
  alias Dreadnought.Multiplayer.NewPlayer
  alias Dreadnought.Sessions.Players
  alias Dreadnought.Sessions.Missions

  # *** *******************************
  # *** ROOM JOIN / LEAVE

  def room_join_types, do: NewPlayer.types()

  defdelegate room_join_changeset(data, attrs), to: NewPlayer, as: :changeset

  defdelegate room_join_validate(attrs), to: NewPlayer, as: :validate

  def join_room(room_join) do
    :ok = Missions.add_player(room_join)
    :ok = Players.set_room(room_join)
  end

  def leave_room(player_uuid) do
    room_name = Players.get_room_name(player_uuid)
    Players.leave_room(player_uuid)
    Missions.drop_player(room_name, player_uuid)
  end

  # *** *******************************
  # *** GET MISSION

  def get_mission_from_player_uuid(player_uuid) do
    with {:ok, room_name} <- Players.fetch_room_name(player_uuid),
         {:ok, room}      <- Missions.fetch(room_name) do
      room
    else
      _response ->
        nil
    end
  end

  # *** *******************************
  # *** UPDATE MISSION

  # TODO `Sessions` seems like the wrong name for this api...

  def complete_player_turn(room_name, %ActionSelection{} = action_selection) do
    fun = &Mission.put(&1, action_selection)
    Missions.update_then_send_all(room_name, fun)
  end

end
