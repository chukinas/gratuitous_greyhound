alias Dreadnought.Core.{ManeuverPlanning, Unit}
alias Dreadnought.Geometry.GridSquare

# TODO rename ManeuverPlanning.Data?
defmodule ManeuverPlanning.Token do
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
    # TODO change any to Position
    field :move_to, (Unit.t(), any -> Unit.t())
  end

  # *** *******************************
  # *** NEW

  def new(
    unit, square, get_squares, target_depth, move_to
  ) when is_function(get_squares) do
    %__MODULE__{
      original_square: square,
      current_square: square,
      current_unit: move_to.(unit, square.center),
      current_depth: 1,
      target_depth: target_depth,
      get_squares: get_squares,
      move_to: move_to
    }
  end

  # *** *******************************
  # *** GETTERS

  def square(%__MODULE__{original_square: square}), do: square

  def position(%__MODULE__{original_square: square}), do: square.center

  # *** *******************************
  # *** API

  # Return list of tokens
  def expand(%__MODULE__{
    target_depth: target,
    current_depth: current
  } = token) when target == current do
    [token]
  end
  def expand(%__MODULE__{
    current_unit: unit,
    current_depth: current_depth,
    get_squares: get_squares
  } = token) do
    get_squares.(unit) |> Stream.map(fn square ->
      %{token |
        current_square: square,
        current_unit: token.move_to.(unit, square.center),
        current_depth: 1 + current_depth,
      }
    end)
  end
end
