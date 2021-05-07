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
end
