alias Chukinas.Dreadnought.Mount
alias Chukinas.Geometry.Position

defmodule Mount do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: true do
    field :id, integer()
    field :position, Position.t()
  end

  # *** *******************************
  # *** NEW

  def new(id, position) do
    %__MODULE__{id: id, position: position}
  end

  # *** *******************************
  # *** GETTERS

  def position(%__MODULE__{position: position}), do: position

  # *** *******************************
  # *** API

  def scale(%__MODULE__{} = mount, scale) do
    Map.update!(mount, :position, &Position.multiply(&1, scale))
  end

  # *** *******************************
  # *** IMPLEMENTATIONS
  #
  #  defimpl Inspect do
  #    import Inspect.Algebra
  #    def inspect(mount, opts) do
  #      col = fn string -> color(string, :cust_struct, opts) end
  #      concat [
  #        col.("#Mount-#{mount.id}<"),
  #        to_doc(mount.position.x |> round, opts),
  #        ", ",
  #        to_doc(mount.position.y |> round, opts),
  #        col.(">")
  #      ]
  #    end
  #  end
end
