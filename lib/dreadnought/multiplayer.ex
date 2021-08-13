defmodule Dreadnought.Multiplayer do

  alias Dreadnought.Multiplayer.NewPlayer
  alias Dreadnought.Sessions.Missions

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
      |> IOP.inspect("Multiplayer")
      |> Missions.add_player
    else
      {:error, changeset}
    end
  end

end
