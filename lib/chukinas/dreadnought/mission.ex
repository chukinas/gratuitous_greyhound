alias Chukinas.Dreadnought.{Unit, Mission, ById, CommandQueue, Segment, CommandIds}
alias Chukinas.Geometry.{Rect, Grid, GridSquare, Size, Collide, Path}

defmodule Mission do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :arena, Rect.t(), enforce: false
    field :grid, Grid.t(), enforce: false
    field :squares, [GridSquare.t()], enforce: false
    field :world, Size.t(), enforce: false
    field :margin, Size.t(), enforce: false
    field :unit, Unit.t(), enforce: false
    field :units, [Unit.t()], default: []
    field :decks, [CommandQueue.t()], default: []
    field :segments, [Segment.t()], default: []
    field :hand, [Command.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(), do: %__MODULE__{}

  # *** *******************************
  # *** GETTERS

  def unit(%__MODULE__{} = mission, %CommandIds{unit: id}), do: unit(mission, id)
  def unit(%__MODULE__{} = mission, id) when is_integer(id), do: ById.get(mission.units, id)
  def get_unit(%__MODULE__{} = mission, id), do: unit(mission, id)

  def deck(%__MODULE__{} = mission, %CommandIds{unit: id}) do
    mission.decks |> ById.get(id)
  end

  def segment(%__module__{} = mission, unit_id, segment_id) do
    mission.segments
    |> Enum.find(fn seg -> Segment.match?(seg, unit_id, segment_id) end)
  end

  # TODO use the bang on the other getters that need it
  def arena!(%__MODULE__{arena: nil}), do: raise "Error: no arena has been set!"
  def arena!(%__MODULE__{arena: arena}), do: arena

  # *** *******************************
  # *** SETTERS

  # TODO rename put
  # TODO are these private?
  # TODO it would be easier if these were maps. Units and Decks would be maps; Segments a list
  def push(%__MODULE__{units: units} = mission, %Unit{} = unit) do
    %{mission | units: ById.insert(units, unit)}
  end
  def push(%__MODULE__{decks: decks} = mission, %CommandQueue{} = deck) do
    %{mission | decks: ById.insert(decks, deck)}
  end

  def put(mission, unit), do: push(mission, unit)

  def set_arena(%__MODULE__{} = mission, width, height) do
    %{mission | arena: Rect.new(width, height)}
  end
  # TODO get rid of this one
  def set_arena(%__MODULE__{} = mission, %Rect{} = arena) do
    %{mission | arena: arena}
  end
  def set_segments(%__MODULE__{} = mission, segments) do
    %{mission | segments: segments}
  end

  def set_grid(mission, square_size, x_count, y_count, %Size{} = margin) do
    grid = Grid.new(square_size, x_count, y_count)
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

  def set_unit(mission, unit), do: %{mission | unit: unit}

  # *** *******************************
  # *** API

  # TODO rename set colliding squares?
  def set_overlapping_squares(mission, shape) do
    collides? = fn square -> Collide.collide?(shape, square) end
    colliding_squares =
      Grid.squares(mission.grid)
      |> Enum.filter(collides?)
    %{mission | squares: colliding_squares}
  end

  def issue_command(%__MODULE__{} = mission, %CommandIds{} = cmd) do
    deck =
      mission
      |> deck(cmd)
      |> CommandQueue.issue_command(cmd)
    start_pose = mission |> unit(cmd) |> Unit.start_pose()
    segments = CommandQueue.build_segments(deck, start_pose, mission.arena)
    mission
    |> push(deck)
    |> set_segments(segments)
  end

  def select_command(%__MODULE__{decks: [deck]} = mission, _player_id, command_id) when is_integer(command_id) do
    deck =
      deck
      |> CommandQueue.select_command(command_id)
    mission
    |> Mission.put(deck)
  end

  def issue_selected_command(%__MODULE__{decks: [deck]} = mission, step_id) when is_integer(step_id) do
    deck =
      deck
      |> CommandQueue.issue_selected_command(step_id)
    start_pose = mission |> unit(2) |> Unit.start_pose()
    segments = CommandQueue.build_segments(deck, start_pose, mission.arena)
    mission
    |> put(deck)
    |> set_segments(segments)
  end

  def build_view(%__MODULE__{decks: [deck | []]} = mission) do
    %{ mission | hand: deck |> CommandQueue.hand}
  end
  def build_view(%__MODULE__{} = mission), do: mission

  def move_unit_to(%__MODULE__{} = mission, position) do
    path = Path.get_connecting_path(mission.unit.pose, position)
    new_pose = Path.get_end_pose path
    unit = Unit.set_pose(mission.unit, new_pose, mission.margin)
           |> IOP.inspect
    motion_range_polygon = Unit.get_motion_range unit
    mission
    |> Mission.set_unit(unit)
    |> Mission.set_overlapping_squares(motion_range_polygon)
  end

  # *** *******************************
  # *** PRIVATE

  # defp update_unit_segments(%__MODULE__{} = mission) do
  #   unit_ids =
  #     mission.decks
  #     |> Enum.map(&CommandQueue.get_id/1)
  #   update_unit_segments(mission, unit_ids)
  # end

  # defp update_unit_segments(%__MODULE__{} = mission, [id]) do
  #   update_unit_segments(mission, id)
  # end

  # defp update_unit_segments(%__MODULE__{} = mission, [id | remaining_ids]) do
  #   update_unit_segments(mission, id)
  #   |> update_unit_segments(remaining_ids)
  # end

  # defp update_unit_segments(%__MODULE__{} = mission, unit_id) when is_integer(unit_id) do
  #   deck = get_deck mission, unit_id
  #   unit = get_unit(mission, unit_id)
  #   start_pose = unit |> Unit.start_pose()
  #   arena = mission.arena
  #   segments = CommandQueue.build_segments deck, start_pose, arena
  #   unit = Unit.set_segments(unit, segments)
  #   push(mission, unit)
  # end
end
