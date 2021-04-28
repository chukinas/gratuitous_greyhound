alias Chukinas.Dreadnought.{UnitManeuver, Unit, UnitOrders}
alias Chukinas.Geometry.{GridSquare}

defmodule UnitManeuver do
  @moduledoc """
  Logic for calculating the maneuver options available to a unit
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :original_square, GridSquare.t()
    field :current_square, GridSquare.t()
    field :current_unit, Unit.t()
    field :current_depth, integer()
    field :target_depth, integer()
    field :get_squares, (Unit.t() -> [GridSquare.t()])
  end

  def position(%__MODULE__{original_square: square}), do: square.center

  def get_stream(unit, grid, islands, target_depth) do
    get_squares = fn unit -> UnitOrders.get_cmd_squares(unit, grid, islands) |> Enum.shuffle end
    original_squares = get_squares.(unit)
    initial_tokens = Stream.map(original_squares, fn square ->
      %__MODULE__{
        original_square: square,
        current_square: square,
        current_unit: Unit.move_to(unit, square.center),
        current_depth: 1,
        target_depth: target_depth,
        get_squares: get_squares
      }
    end)
    Stream.flat_map(initial_tokens, fn token ->
      expand_token(token)
    end)
  end

  # Return list of tokens
  defp expand_token(%{
    target_depth: target,
    current_depth: current
  } = token) when target == current do
    [token]
  end
  defp expand_token(%__MODULE__{
    current_unit: unit,
    current_depth: current_depth,
    get_squares: get_squares
  } = token) do
    get_squares.(unit) |> Stream.map(fn square ->
      %{token |
        current_square: square,
        current_unit: Unit.move_to(unit, square.center),
        current_depth: 1 + current_depth,
      }
    end)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(path, opts) do
      unit_map = path |> Map.take([:id, :pose, :maneuver_svg_string, :player_id])
      concat ["#PotPath<", to_doc(unit_map, opts), ">"]
    end
  end
end
