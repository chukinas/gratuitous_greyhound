alias Chukinas.Dreadnought.{Unit, Mission, ById, Island}
alias Chukinas.Geometry.{Rect, Grid, GridSquare, Size, Collide, Path}

defmodule Mission do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :arena, Rect.t()
    field :grid, Grid.t()
    field :squares, [GridSquare.t()]
    field :world, Size.t()
    field :margin, Size.t()
    field :game_over?, boolean(), default: false
    field :islands, [Island.t()], default: []
    field :units, [Unit.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(), do: %__MODULE__{}

  # *** *******************************
  # *** SETTERS

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

  def calc_command_squares(mission, command_zone) do
    # TODO 185
    unit = ById.get(mission.units, 1)
    command_squares =
      mission.grid
      |> Grid.squares(include: command_zone, exclude: mission.islands)
      |> Stream.map(&GridSquare.calc_path(&1, unit.pose))
      |> Stream.filter(&Collide.avoids?(&1.path, mission.islands))
      |> Enum.to_list
    %{mission | squares: command_squares}
  end

  # TODO remove path_type?
  def move_unit_to(%__MODULE__{} = mission, unit_id, position, path_type \\ :straight) do
    # TODO most of this stuff belongs in unit module
    unit = ById.get!(mission.units, unit_id)
    path = Path.get_connecting_path(unit.pose, position)
    unit = Unit.move_along_path(unit, path)
    trim_angle = cond do
      path_type == :sharp_turn and path.angle > 0
        -> 30
      path_type == :sharp_turn
        -> -30
      true
        -> 0
    end
    motion_range_polygon = Unit.get_motion_range(unit, trim_angle)
    mission
    |> put(unit)
    |> calc_command_squares(motion_range_polygon)
  end

  def game_over?(mission), do: Enum.empty? mission.squares

  def calc_game_over(mission), do: %{mission | game_over?: game_over? mission}
end
