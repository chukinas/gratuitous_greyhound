alias Chukinas.Dreadnought.{Unit, Sprite, Spritesheet, Turret, Command}
alias Chukinas.Geometry.{Pose, Position, Turn, Straight, Polygon, Path}
alias Chukinas.Svg

defmodule Command do
  @moduledoc """
  Represents the actions a unit will take at the end of the turn
  """

  # *** *******************************
  # *** TYPES

  @type unit_id() :: integer()

  use TypedStruct

  typedstruct do
    field :move_to, Position.t()
    field :attack, unit_id()
  end

  def new(opts \\ []), do: struct!(__MODULE__, opts)
end
