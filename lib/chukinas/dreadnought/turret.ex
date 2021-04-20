alias Chukinas.Dreadnought.{Turret, Sprite}
alias Chukinas.Geometry.{Pose}

defmodule Turret do
  @moduledoc """
  Represents a weapon on a unit (ship, fortification, etc)
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :pose, Pose.t()
    # TODO sprite should have a name
    field :sprite, Sprite.t()
  end

  # *** *******************************
  # *** NEW

  def new(id, pose, sprite) do
    %__MODULE__{
      id: id,
      pose: pose,
      sprite: sprite
    }
    |> IOP.inspect("turret")
  end
end
