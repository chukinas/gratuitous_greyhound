alias Chukinas.Dreadnought.{UnitOrders, Unit}
alias Chukinas.Geometry.{Position, Collide, Grid, Position, GridSquare}

defmodule UnitOrders do
  @moduledoc """
  Represents the actions a unit will take at the end of the turn
  """

  # *** *******************************
  # *** TYPES

  @type unit_id() :: integer()

  use TypedStruct
  typedstruct do
    field :unit_id, unit_id(), enforce: true
    field :commands, [:exit_or_run_aground | {:move_to, Position.t()}]
  end

  # *** *******************************
  # *** NEW

  def new(opts \\ []), do: struct!(__MODULE__, opts)

  def move_to(unit_id, position), do: new(unit_id: unit_id, commands: [{:move_to, position}])
  def exit_or_run_aground(unit_id), do: new(unit_id: unit_id, commands: [:exit_or_run_aground])

  # *** *******************************
  # *** MANEUVER PLANNING

  # def get_cmd_squares(unit, grid) do
  #   get_cmd_squares(unit, grid, [])
  # end

  # TODO does this belong in PotentialPath?
  def get_cmd_squares(%{pose: pose} = unit, grid, islands) do
    maneuver_polygon = Unit.get_maneuver_polygon(unit)
    grid
    |> Grid.squares(include: maneuver_polygon, exclude: islands)
    |> Stream.map(&GridSquare.calc_path(&1, pose))
    |> Stream.filter(&Collide.avoids?(&1.path, islands))
  end
end
