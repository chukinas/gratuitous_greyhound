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

  def new(), do: %__MODULE__{}

  # *** *******************************
  # *** SETTERS

  def put(mission, list) when is_list(list) do
    Enum.reduce(list, mission, fn item, mission ->
      put(mission, item)
    end)
  end
  def put(mission, %Unit{} = unit) do
    Map.update! mission, :units, fn units ->
      units
      |> Enum.reject(& &1.id == unit.id)
      |> Enum.concat([unit])
    end
  end

  def put_dimensions(mission, %Grid{} = grid, %Size{} = margin) do
    world = Size.new(
      grid.width + 2 * margin.width,
      grid.height + 2 * margin.height
    )
    %{mission |
      grid: grid,
      world: world,
      margin: margin,
    }
  end

  # *** *******************************
  # *** API

  def initialize(%{grid: grid, islands: islands} = mission) do
    units =
      mission.units
      |> Enum.map(& Unit.calc_cmd_squares &1, grid, islands)
    %{mission | units: units}
  end

  # TODO delete?
  # TODO private?
  def move_unit_to(mission, unit_id, position, _path_type) do
    unit =
      mission.unit
      |> ById.get!(unit_id)
      |> Unit.move_to(position)
    put(mission, unit)
  end

  def to_playing_surface(mission), do: Mission.PlayingSurface.new(mission)
  def to_player(mission), do: Mission.Player.new(mission.units)

  def complete_player_turn(mission, player_turn) do
    Enum.reduce(player_turn.commands, mission, fn cmd, mission ->
      resolve_command(mission, cmd)
    end)
  end

  # *** *******************************
  # *** PRIVATE

  defp resolve_command(mission, command) do
    unit =
      mission.units
      |> Enum.find(& &1.id == command.unit_id)
      |> Unit.resolve_command(command, mission.grid, mission.islands)
    put(mission, unit)
  end
end
