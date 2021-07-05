defmodule Chukinas.Dreadnought.Mission do

  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.ActionSelection
  alias Chukinas.Dreadnought.CombatAction
  alias Chukinas.Dreadnought.Gunfire
  alias Chukinas.Dreadnought.Island
  alias Chukinas.Dreadnought.Maneuver
  alias Chukinas.Dreadnought.Player
  alias Chukinas.Dreadnought.PlayerTurn
  alias Chukinas.Dreadnought.Unit
  alias Chukinas.Dreadnought.UnitAction
  alias Chukinas.Geometry.Grid
  alias Chukinas.Geometry.Rect
  alias Chukinas.Util.IdList
  alias Chukinas.Util.Maps

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct do
    field :room_name, String.t, enforce: true
    field :world_rect, Rect.t, enforce: true
    field :grid, Grid.t(), enforce: true
    field :turn_number, integer(), default: 0
    # TODO deprecate
    field :world, any
    # TODO deprecate
    field :margin, any
    field :islands, [Island.t()], default: []
    field :units, [Unit.t()], default: []
    field :players, [Player.t()], default: []
    field :player_actions, [ActionSelection.t()], default: []
    field :gunfire, [Gunfire.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(room_name, %Grid{} = grid, margin) when has_size(margin) do
    %__MODULE__{
      room_name: room_name,
      world_rect: world_rect(grid, margin),
      world: world_rect(grid, margin) |> size_new,
      grid: grid,
      margin: margin,
    }
  end

  defp world_rect(grid, margin) do
    position =
      margin
      |> position_from_size
      |> position_multiply(-1)
    size =
      margin
      |> size_multiply(2)
      |> size_add(grid)
    Rect.from_position_and_size(position, size)
  end

  # *** *******************************
  # *** GETTERS (PLAYERS)

  def players(%{players: value}), do: value

  def player_ids(mission), do: IdList.ids(mission.players)

  def completed_player_ids(mission) do
    IdList.ids(mission.player_actions, :player_id)
  end

  def ai_player_ids(mission) do
    mission
    |> players
    |> Stream.filter(&Player.ai?/1)
    |> Stream.map(&Player.id/1)
  end

  def player_count(mission) do
    mission
    |> players
    |> Enum.count
  end

  # *** *******************************
  # *** GETTERS

  def in_progress?(mission) do
    turn_number(mission) > 0
  end

  def turn_number(%__MODULE__{turn_number: value}), do: value

  def to_player(mission), do: PlayerTurn.map(1, :human,  mission)

  defp turn_complete?(mission) do
    player_ids = mission |> player_ids |> MapSet.new
    completed_player_ids = mission |> completed_player_ids |> MapSet.new
    MapSet.equal?(player_ids, completed_player_ids)
  end

  defp commands(%__MODULE__{player_actions: actions}) do
    # TODO rename unit_actions
    Stream.flat_map(actions, &ActionSelection.actions/1)
  end

  defp actions(mission), do: commands(mission)

  defp maneuver_actions(%__MODULE__{} = mission) do
    mission
    |> commands
    |> UnitAction.Enum.maneuevers
  end

  def units(%{units: units}), do: units

  @spec unit_count(t) :: integer
  def unit_count(mission) do
    mission
    |> units
    |> Enum.count
  end

  def combats(mission), do: mission |> actions |> UnitAction.Enum.combats

  # TODO rename `world_rect`
  def rect(nil), do: Rect.null()
  def rect(%__MODULE__{world_rect: value}), do: value

  def islands(nil), do: []
  def islands(%__MODULE__{islands: value}), do: value

  # *** *******************************
  # *** SETTERS

  def put(mission, list) when is_list(list), do: Enum.reduce(list, mission, &put(&2, &1))
  def put(mission, %Unit{} = unit), do: Maps.put_by_id(mission, :units, unit)
  def put(mission, %Player{} = player), do: Maps.put_by_id(mission, :players, player)
  def put(mission, %ActionSelection{} = player_actions) do
    mission
    |> Maps.put_by_id(:player_actions, player_actions, :player_id)
    |> maybe_end_turn
  end

  def push_gunfire(mission, gunfire) do
    Maps.push(mission, :gunfire, gunfire)
  end


  # *** *******************************
  # *** CALC

  def calc_ai_commands(mission) do
    Enum.reduce(ai_player_ids(mission), mission, fn player_id, mission ->
      %PlayerTurn{player_actions: actions} = PlayerTurn.new(player_id, :ai, mission)
      mission |> put(actions)
    end)
  end

  def start(mission) do
    mission
    |> increment_turn_number
    |> calc_ai_commands
  end

  defp maybe_end_turn(mission) do
    if turn_complete?(mission), do: begin_new_turn(mission), else: mission
  end

  defp begin_new_turn(mission) do
    mission
    # Part 1: Clean up and increment
    |> increment_turn_number
    |> clear_units
    |> clear_gunfire
    # Part 2: Execute previous turn's planning
    |> put_tentative_maneuvers
    |> resolve_island_collisions
    |> calc_gunnery
    |> check_for_destroyed_ships
    |> calc_unit_status
    # Part 3: Prepare for this turn's planning
    |> clear_player_actions
    |> calc_ai_commands
  end

  defp clear_gunfire(mission), do: Maps.clear(mission, :gunfire)

  defp clear_player_actions(mission) do
    %__MODULE__{mission | player_actions: []}
  end

  defp clear_units(mission), do: Maps.map_each(mission, :units, &Unit.clear/1)

  defp increment_turn_number(mission) do
    Map.update!(mission, :turn_number, & &1 + 1)
  end

  defp put_tentative_maneuvers(mission) do
    Enum.reduce(maneuver_actions(mission), mission, fn maneuver, mission ->
      %Unit{} = unit = Maneuver.get_unit_with_tentative_maneuver(mission.units, maneuver, mission.turn_number)
      mission |> put(unit)
    end)
  end

  defp resolve_island_collisions(mission) do
    mission
  end

  defp calc_gunnery(mission) do
    Enum.reduce(combats(mission), mission, fn combat_action, mission ->
      {units, gunfire} = CombatAction.exec(combat_action, mission)
      %__MODULE__{mission | units: units}
      |> push_gunfire(gunfire)
    end)
  end

  defp calc_unit_status(mission) do
    Maps.map_each(mission, :units, &Unit.Status.Logic.calc_status/1)
  end

  defp check_for_destroyed_ships(mission) do
    units =
      mission
      |> units
      |> Unit.Enum.active_units
      |> Enum.map(&Unit.maybe_destroyed/1)
    put(mission, units)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    require IOP
    def inspect(mission, opts) do
      title = "Mission-Turn-#{mission.turn_number}"
      fields =
        mission
        |> Map.take([
          :room_name,
          :units,
          :players
        ])
        |> Enum.into([])
      IOP.struct(title, fields)
    end
  end
end
