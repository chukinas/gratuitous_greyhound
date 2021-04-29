alias Chukinas.Dreadnought.{PathPartial}
alias Chukinas.Geometry.Path
alias Chukinas.Svg

defmodule PathPartial do
  @moduledoc """
  Fully qualifies a portion of a unit's path

  A list of these (or even none or just one) is used by the frontend
  to render a series of motion animations.
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :geo_path, Path.t()
    field :svg_path, String.t()
    field :fractional_start_time, number(), default: 0
    field :fractional_duration, number(), default: 1
  end

  def new(geo_path) do
    %__MODULE__{
      geo_path: geo_path,
      svg_path: Svg.get_path_string(geo_path)
    }
  end

  def new_list(geo_path), do: [new(geo_path)]
end
