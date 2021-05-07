alias Chukinas.Dreadnought.{Gunfire, Spritesheet}

defmodule Gunfire do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :sprite, Sprite.t()
    field :pose, Pose.t()
    #field :time_start, number()
    #field :time_duration, number()
  end

  # *** *******************************
  # *** NEW

  def new(pose) do
    spritename = "explosion_" <> Enum.random(~w(1 2 3))
    sprite = Spritesheet.blue(spritename)
    %__MODULE__{
      sprite: sprite,
      pose: pose,
    }
  end

  # *** *******************************
  # *** GETTERS


  # *** *******************************
  # *** SETTERS


  # *** *******************************
  # *** API

  # *** *******************************
  # *** PRIVATE

end
