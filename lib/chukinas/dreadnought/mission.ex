# TODO ById should be a utility
alias Chukinas.Dreadnought.{Unit, Mission, ById, Island, ActionSelection, Player}
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
    mission.players
    |> Enum.flat_map(& &1.action_selection.commands)
    |> IOP.inspect("commands")
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

  # *** *******************************
  # *** API

  def to_playing_surface(mission), do: Mission.PlayingSurface.new(mission)
  def to_player(mission), do: Mission.Player.map(1, mission)

  def calc_ai_commands(mission) do
    ai_action_selections =
      mission
      |> players
      |> Stream.filter(&Player.is_ai/1)
      |> Stream.map(&Player.id/1)
      |> Enum.reduce([], fn player_id, action_selections ->
        action_selection = ActionSelection.new(mission.units, player_id)
        [action_selection | action_selections]
      end)

    ai_player_turn = to_player(mission)
    mission
  end

  # *** *******************************
  # *** PLAYER INPUT

  def complete_player_turn(mission, %ActionSelection{player_id: player_id} = action_selection) do
    players =
      mission.players
      |> Map.update!(player_id, &Player.put_commands(&1, action_selection.commands))
    # TODO use put it
    mission =
      %{mission | players: players}
    if turn_complete?(mission) do
      mission
      |> resolve_commands
      |> increment_turn_number
    else
      mission
    end
  end

  defp turn_complete?(mission) do
    mission
    |> players
    |> Enum.all?(&Player.turn_complete?/1)
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
      |> Unit.resolve_command(command)
    put(mission, unit)
  end
end
