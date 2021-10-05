defmodule Dreadnought.Core.Mount do

  use Spatial.PositionOrientationSize
  use Spatial.TypedStruct

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    position_fields()
    field :id, integer()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(id, position) do
    fields =
      %{id: id}
      |> merge_position(position)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** REDUCERS

  # TODO remove
  def scale(%__MODULE__{} = mount, scale) do
    position_multiply(mount, scale)
  end

end

# *** *********************************
# *** IMPLEMENTATIONS
# *** *********************************

defimpl Inspect, for: Dreadnought.Core.Mount do
  import Inspect.Algebra
  def inspect(mount, opts) do
    col = fn string -> color(string, :cust_struct, opts) end
    concat [
      col.("#Mount-#{mount.id}<"),
      to_doc(mount.x |> round, opts),
      ", ",
      to_doc(mount.y |> round, opts),
      col.(">")
    ]
  end
end

