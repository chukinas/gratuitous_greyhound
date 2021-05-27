alias Chukinas.Dreadnought.Mount

defmodule Mount do

  use Chukinas.PositionOrientationSize

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    field :id, integer()
    position_fields()
  end

  # *** *******************************
  # *** NEW

  def new(id, position) do
    [position: position]
    |> pos_into_struct(__MODULE__, id: id)
  end

  # *** *******************************
  # *** API

  def scale(%__MODULE__{} = mount, scale) do
    Map.update!(mount, :position, &position_multiply(&1, scale))
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(mount, opts) do
      col = fn string -> color(string, :cust_struct, opts) end
      concat [
        col.("#Mount-#{mount.id}<"),
        to_doc(mount.position.x |> round, opts),
        ", ",
        to_doc(mount.position.y |> round, opts),
        col.(">")
      ]
    end
  end
end
