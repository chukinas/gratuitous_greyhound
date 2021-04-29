# TODO ById should be a utility
alias Chukinas.Dreadnought.{Unit, Mission, ById, Island, PlayerActions, Player, PlayerTurn, ArtificialIntelligence, UnitAction}
alias Chukinas.Geometry.{Grid, Size, Position}

defmodule Mission do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :turn_number, integer(), default: 1
    field :grid, Grid.t()
    field :world, Size.t()
    field :margin, Size.t()
    field :islands, [Island.t()], default: []
    field :units, [Unit.t()], default: []
    field :players, [Player.t()], default: []
    field :player_actions, [PlayerActions.t()], default: []
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
  # *** GETTERS

  def players(mission), do: mission.players
  # TODO rename unit_actions
  defp commands(%__MODULE__{player_actions: actions}) do
    Enum.flat_map(actions, &PlayerActions.commands/1)
  end
  defp maneuver_actions(%__MODULE__{} = mission) do
    mission
    |> commands
    |> UnitAction.List.maneuevers
  end
  def player_ids(mission), do: ById.to_ids(mission.players)
  def completed_player_ids(mission) do
    ById.to_ids(mission.player_actions, :player_id)
  end
  def ai_player_ids(mission) do
    mission
    |> players
    |> Stream.filter(&Player.ai?/1)
    |> Stream.map(&Player.id/1)
  end
  def units(%{units: units}), do: units

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
  def put(mission, %Player{} = player) do
    Map.update!(mission, :players, &ById.put(&1, player))
  end
  def put(mission, %PlayerActions{} = player_actions) do
    mission
    |> Map.update!(:player_actions, &ById.put(&1, player_actions, :player_id))
    |> maybe_end_turn
  end

  # *** *******************************
  # *** API

  def to_playing_surface(mission), do: Mission.PlayingSurface.new(mission)
  def to_player(mission), do: PlayerTurn.map(1, mission)

  def calc_ai_commands(mission) do
    Enum.reduce(ai_player_ids(mission), mission, fn player_id, mission ->
      new_player_actions = PlayerActions.new(mission.units, player_id)
      complete_player_actions =
        new_player_actions
        |> ArtificialIntelligence.calc_commands(mission.units, mission.grid, mission.islands)
      mission |> put(complete_player_actions)
    end)
  end

  def start(mission) do
    mission
    |> calc_ai_commands
  end

  # *** *******************************
  # *** PRIVATE

  defp maybe_end_turn(mission) do
    if turn_complete?(mission) do
      mission
      # Resolve current turn
      |> put_tentative_maneuvers
      |> resolve_island_collisions
      # New turn prep
      |> clear_player_actions
      |> increment_turn_number
      |> calc_ai_commands
    else
      mission
    end
  end

  defp clear_player_actions(mission) do
    %__MODULE__{mission | player_actions: []}
  end

  defp turn_complete?(mission) do
    player_ids = mission |> player_ids |> MapSet.new
    completed_player_ids = mission |> completed_player_ids |> MapSet.new
    MapSet.equal?(player_ids, completed_player_ids)
  end

  defp increment_turn_number(mission) do
    Map.update!(mission, :turn_number, & &1 + 1)
  end

  defp put_tentative_maneuvers(mission) do
    Enum.reduce(maneuver_actions(mission), mission, fn maneuver, mission ->
      # TODO rename apply_...?
      calc_tentative_maneuver(mission, maneuver)
    end)
  end

  defp resolve_island_collisions(mission) do
    mission
  end

  defp calc_tentative_maneuver(mission, maneuver_action) do
    unit = mission |> units |> ById.get!(maneuver_action.unit_id)
    unit = case UnitAction.value(maneuver_action) do
      %Position{} = pos -> Unit.move_to unit, pos
    end
    mission |> put(unit)
  end
end
