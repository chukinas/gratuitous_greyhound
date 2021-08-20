defmodule Dreadnought.Core.Mission do

  use Dreadnought.Core.Mission.Spec
  use Dreadnought.PositionOrientationSize
  use TypedStruct
  alias Dreadnought.Core.ActionSelection
  alias Dreadnought.Core.CombatAction
  alias Dreadnought.Core.Gunfire
  alias Dreadnought.Core.Island
  alias Dreadnought.Core.Maneuver
  alias Dreadnought.Core.Player
  alias Dreadnought.Core.Unit
  alias Dreadnought.Core.UnitAction
  alias Dreadnought.Geometry.Grid
  alias Dreadnought.Geometry.Rect
  alias Dreadnought.Util.IdList
  alias Dreadnought.Util.Maps
  alias Dreadnought.Util.Slugs

  # *** *******************************
  # *** TYPES

  typedstruct do
    field :mission_spec, mission_spec
    field :name_pretty, String.t, enforce: true
    # play area + margin:
    field :world_rect, Rect.t, enforce: true
    # TODO deprectate. Replace with grid square size
    field :grid, Grid.t(), enforce: true
    field :turn_number, integer(), default: 0
    # TODO deprecate?
    field :margin, any
    field :islands, [Island.t()], default: []
    field :units, [Unit.t()], default: []
    field :players, [Player.t()], default: []
    field :player_actions, [ActionSelection.t()], default: []
    # TODO rename
    field :gunfire, [Gunfire.t()], default: []
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(mission_spec, %Grid{} = grid, margin)
  when has_size(margin)
  and is_mission_spec(mission_spec) do
    %__MODULE__{
      mission_spec: mission_spec,
      name_pretty: mission_spec |> name_from_mission_spec |> Slugs.pretty,
      world_rect: world_rect(grid, margin),
      grid: grid,
      margin: margin
    }
  end

  # TODO move somewhere else
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
  # *** REDUCERS (PLAYERS)

  def add_player(%__MODULE__{} = mission, player) do
    player_id = next_player_id(mission)
    mission
    |> drop_player(player)
    |> put(Player.put_id(player, player_id))
  end

  def drop_player(mission, %Player{} = player) do
    uuid = Player.uuid(player)
    drop_player_by_uuid(mission, uuid)
  end

  def drop_player_by_uuid(mission, uuid) do
    update_players(mission, &Player.Enum.exclude_uuid(&1, uuid))
  end

  def next_player_id(%__MODULE__{} = mission) do
    1 + max(highest_player_id(mission), player_count(mission))
  end

  def highest_player_id(mission) do
    mission
    |> players
    |> Stream.map(&Player.id/1)
    |> Enum.max(fn -> 0 end)
  end

  def toggle_player_ready(%__MODULE__{} = mission, player_or_player_id) do
    player_id =
      case player_or_player_id do
        %Player{} = player ->
          mission
          |> player_by_uuid(player)
          |> Player.id
        player_id when is_integer(player_id) ->
          player_id
      end
    player_update =
      fn players ->
        IdList.update!(players, player_id, &Player.toggle_ready/1)
      end
    mission
    |> update_players(player_update)
    |> maybe_start
  end

  # *** *******************************
  # *** REDUCERS

  def put(mission, list) when is_list(list), do: Enum.reduce(list, mission, &put(&2, &1))
  def put(mission, %Unit{} = unit), do: Maps.put_by_id(mission, :units, unit)
  def put(mission, %Player{id: id} = player) when is_integer(id) do
    # TODO should I check more than just the id?
    Maps.put_by_id(mission, :players, player)
  end
  def put(mission, %ActionSelection{} = player_actions) do
    mission
    |> Maps.put_by_id(:player_actions, player_actions, :player_id)
    |> maybe_end_turn
  end

  # TODO decouple the update and the new turn
  def put_action_selection_and_end_turn(mission, %ActionSelection{} = actions) do
    mission
    |> Maps.put_by_id(:player_actions, actions, :player_id)
    |> begin_new_turn
  end

  # TODO when I add the ai back in, I'll have to do this elsewhere since
  # PlayerTurn now has dependency on Mission
  #def calc_ai_commands(mission) do
  #  Enum.reduce(ai_player_ids(mission), mission, fn player_id, mission ->
  #    %PlayerTurn{player_actions: actions} = PlayerTurn.new(player_id, :ai, mission)
  #    mission |> put(actions)
  #  end)
  #end

  def maybe_start(mission) do
    if ready?(mission), do: start(mission), else: mission
  end

  def start(mission) do
    mission
    |> increment_turn_number
    #|> calc_ai_commands
  end

  def update_unit(mission, unit_id, fun) do
    update_units = &IdList.update!(&1, unit_id, fun)
    Map.update!(mission, :units, update_units)
  end

  def clear_units(mission) do
    mission
    |> clear_gunfire
    |> Maps.clear(:units)
    |> Maps.clear(:player_actions)
  end

  # *** *******************************
  # ***  REDUCERS (PRIVATE)

  defp clear_gunfire(mission), do: Maps.clear(mission, :gunfire)

  defp maybe_end_turn(mission) do
    if turn_complete?(mission), do: begin_new_turn(mission), else: mission
  end

  defp push_gunfire(mission, gunfire) do
    Maps.push(mission, :gunfire, gunfire)
  end

  defp begin_new_turn(mission) do
    mission
    # Part 1: Clean up and increment
    |> increment_turn_number
    |> reset_units
    |> clear_gunfire
    # Part 2: Execute previous turn's planning
    |> put_tentative_maneuvers
    |> resolve_island_collisions
    |> calc_gunnery
    |> check_for_destroyed_ships
    |> calc_unit_status
    # Part 3: Prepare for this turn's planning
    |> clear_player_actions
    #|> calc_ai_commands
  end

  defp clear_player_actions(mission) do
    %__MODULE__{mission | player_actions: []}
  end

  defp reset_units(mission), do: Maps.map_each(mission, :units, &Unit.clear/1)

  defp update_players(mission, fun) do
    players =
      mission
      |> players
      |> fun.()
    %__MODULE__{mission | players: players}
  end

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
  # *** CONVERTERS (PLAYERS)

  def player_by_id(mission, player_id) do
    mission
    |> players
    |> IdList.fetch!(player_id)
  end

  def player_by_uuid(mission, player_uuid) do
    mission
    |> players
    |> IdList.fetch!(player_uuid, :uuid)
  end

  def player_uuids(mission), do: (for player <- players(mission), do: Player.uuid(player))

  def players(%__MODULE__{players: value}), do: value

  def player_ids(mission), do: IdList.ids(mission.players)

  def players_sorted(mission) do
    mission
    |> players
    |> Enum.sort_by(&Player.id/1, :asc)
  end

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

  defp players_ready?(mission) do
    mission
    |> players
    |> Enum.all?(&Player.ready?/1)
  end

  # *** *******************************
  # *** CONVERTERS (OTHER)

  def empty?(mission), do: (player_count(mission) == 0)

  def grid(%__MODULE__{grid: value}), do: value

  def in_progress?(mission), do: turn_number(mission) > 0

  # TODO deprecate
  def mission_spec(%__MODULE__{mission_spec: value}), do: value

  def name(%__MODULE__{mission_spec: mission_spec}) do
    name_from_mission_spec(mission_spec)
  end

  def pretty_name(%__MODULE__{name_pretty: value}), do: value

  def ready?(mission) do
    with true <- player_count(mission) in 1..2,
         true <- players_ready?(mission) do
      true
    else
      false -> false
    end
  end

  def spec(%__MODULE__{mission_spec: value}), do: value

  def turn_number(%__MODULE__{turn_number: value}), do: value

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

  def unit_by_id(%__MODULE__{} = mission, id) when is_integer(id) do
    mission
    |> units
    |> IdList.fetch!(id)
  end

  @spec unit_count(t) :: integer
  def unit_count(mission) do
    mission
    |> units
    |> Enum.count
  end

  def combats(mission), do: mission |> actions |> UnitAction.Enum.combats

  # TODO rename `world_rect`
  # TODO can I implement BoundingRect protocol instead?
  def rect(nil), do: Rect.null()
  def rect(%__MODULE__{world_rect: value}), do: value

  # TODO remove the nil func clause here and elsewhere
  def islands(nil), do: []
  def islands(%__MODULE__{islands: value}), do: value

  def arena_rect_wrt_world(nil), do: Rect.null()
  def arena_rect_wrt_world(%__MODULE__{grid: grid, margin: margin}) do
    position =
      margin
      |> position_from_size
    Rect.from_position_and_size(position, grid)
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
          :name,
          :units,
          :players
        ])
        |> Enum.into([])
      IOP.struct(title, fields)
    end
  end
end
