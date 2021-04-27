# TODO ById should be a utility
alias Chukinas.Dreadnought.{Unit, Mission, ById, Island, PlayerActions, Player, PlayerTurn, ArtificialIntelligence}
alias Chukinas.Geometry.{Grid, Size}

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
    field :players, %{integer() => Player.t()}, default: %{}
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

  def players(mission), do: Map.values(mission.players)
  defp commands(mission) do
    mission
    |> players
    |> Enum.flat_map(&Player.commands/1)
    |> IOP.inspect("all commands")
  end

  def ai_player_ids(mission) do
    mission
    |> players
    |> Stream.filter(&Player.ai?/1)
    |> Stream.map(&Player.id/1)
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
  def put(mission, %Player{id: player_id} = player) do
    Map.update!(mission, :players, &Map.put(&1, player_id, player))
  end
  def put(mission, %PlayerActions{player_id: player_id} = player_actions) do
    players =
      mission.players
      |> Map.update!(player_id, &Player.put_commands(&1, player_actions.commands))
    %{mission | players: players}
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
  # *** PLAYER INPUT

  def complete_player_turn(mission, %PlayerActions{} = player_actions) do
    IO.puts "complete player turn"
    mission = mission |> put(player_actions)
    if turn_complete?(mission) do
      mission
      |> resolve_commands
      |> increment_turn_number
      |> calc_ai_commands
    else
      mission
    end
  end

  defp turn_complete?(mission) do
    mission
    |> players
    |> Enum.all?(&Player.turn_complete?/1)
    |> IOP.inspect("turn complete?")
  end

  defp increment_turn_number(mission), do: Map.update!(mission, :turn_number, & &1 + 1)

  defp resolve_commands(mission) do
    Enum.reduce(commands(mission), mission, fn cmd, mission ->
      resolve_command(mission, cmd)
    end)
  end

  defp resolve_command(mission, command) do
    unit =
      mission.units
      |> Enum.find(& &1.id == command.unit_id)
    unit = Enum.reduce(command.commands, unit, fn command, unit ->
      Unit.resolve_command(unit, command)
    end)
    put(mission, unit)
  end
end
