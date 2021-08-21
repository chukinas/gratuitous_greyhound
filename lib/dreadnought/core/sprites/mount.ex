defmodule Dreadnought.Core.Sprites.Mount do

  use Dreadnought.PositionOrientationSize
  use Dreadnought.TypedStruct

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    field :id, integer()
    position_fields()
  end

  # *** *******************************
  # *** NEW

  def new(id, location) do
    fields =
      %{id: id}
      |> merge_position(location)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** API

  def scale(%__MODULE__{} = mount, scale) do
    position_multiply(mount, scale)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
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
end
