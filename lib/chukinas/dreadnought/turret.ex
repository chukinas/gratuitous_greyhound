alias Chukinas.Dreadnought.{Turret, Sprite, Spritesheet}
alias Chukinas.Geometry.{Pose}

defmodule Turret do
  @moduledoc """
  Represents a weapon on a unit (ship, fortification, etc)
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :rest_pose, Pose.t()
    # TODO sprite should have a name
    field :sprite, Sprite.t()
  end

  # *** *******************************
  # *** NEW

  def new(rest_pose, sprite) do
    %__MODULE__{
      rest_pose: rest_pose,
      sprite: sprite
    }
  end
end
