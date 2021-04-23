alias Chukinas.Dreadnought.{Command}
alias Chukinas.Geometry.{Position}

defmodule Command do
  @moduledoc """
  Represents the actions a unit will take at the end of the turn
  """

  # *** *******************************
  # *** TYPES

  @type unit_id() :: integer()

  use TypedStruct

  typedstruct do
    field :unit_id, integer(), enforce: true
    field :move_to, Position.t()
    #field :attack, unit_id()
  end

  # *** *******************************
  # *** NEW

  def new(opts \\ []), do: struct!(__MODULE__, opts)

  def move_to(unit_id, position), do: new(unit_id: unit_id, move_to: position)
end
