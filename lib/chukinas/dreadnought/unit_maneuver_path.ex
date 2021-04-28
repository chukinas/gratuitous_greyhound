alias Chukinas.Dreadnought.{UnitManeuverPath}

defmodule UnitManeuverPath do
  @moduledoc """
  Fully qualifies a portion of a unit's path

  A list of these (or even none or just one) is used by the frontend
  to render a series of motion animations.
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :svg_path, String.t()
    field :fractional_start_time, number(), default: 0
    field :fractional_duration, number(), default: 1
  end

  def new(svg_path) do
    %__MODULE__{svg_path: svg_path}
  end

  def new_list(svg_path), do: [new(svg_path)]
end
