# TODO ById should be a utility
alias Chukinas.Dreadnought.{Unit, Mission, ById, Island}
alias Chukinas.Geometry.{Grid, Size}

defmodule Mission do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :grid, Grid.t()
    field :world, Size.t()
    field :margin, Size.t()
    field :islands, [Island.t()], default: []
    field :units, [Unit.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(%Grid{} = grid, %Size{} = margin) do
    world = Size.new(
      grid.width + 2 * margin.width,
      grid.height + 2 * margin.height
    )
    %__MODULE__{
      world: world,
      grid: grid,
      margin: margin,
    }
  end

  # *** *******************************
  # *** SETTERS

  def put(mission, list) when is_list(list) do
    Enum.reduce(list, mission, fn item, mission ->
      put(mission, item)
    end)
  end
  def put(mission, %Unit{} = unit) do
    Map.update!(mission, :units, & ById.put(&1, unit))
  end

  # *** *******************************
  # ***

  def to_playing_surface(mission), do: Mission.PlayingSurface.new(mission)
  def to_player(mission), do: Mission.Player.new(mission)

  # *** *******************************
  # *** PLAYER INPUT

  def complete_player_turn(mission, player_turn) do
    Enum.reduce(player_turn.commands, mission, fn cmd, mission ->
      resolve_command(mission, cmd)
    end)
  end

  defp resolve_command(mission, command) do
    unit =
      mission.units
      |> Enum.find(& &1.id == command.unit_id)
      |> Unit.resolve_command(command)
    put(mission, unit)
  end
end
