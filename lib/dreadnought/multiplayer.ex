defmodule Dreadnought.Multiplayer do

  alias Dreadnought.Missions
  alias Dreadnought.Multiplayer.NewPlayer
  alias Dreadnought.Multiplayer.Mission, as: MissionBuilder

  def change_new_player(%NewPlayer{} = new_player, attrs \\ %{}) do
    NewPlayer.changeset(new_player, attrs)
  end

  def add_player(%NewPlayer{} = new_player, attrs) do
    # TODO does this return {:ok, new_player}?
    changeset =
      new_player
      |> change_new_player(attrs)
      # TODO use Changeset.apply_changes instead?
      |> Map.put(:action, :validate)
    if changeset.valid? do
      new_player
      |> struct(changeset.changes)
      |> NewPlayer.to_player
      |> Missions.add_player
    else
      {:error, changeset}
    end
  end

  def new_mission(mission_name) do
    IOP.inspect(mission_name, __MODULE__)
    MissionBuilder.new(mission_name)
    |> IOP.inspect(__MODULE__)
  end

end
