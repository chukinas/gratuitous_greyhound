defmodule Chukinas.Dreadnought.AnimationFrame do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enfore: true do
    field :sprite, Chukinas.Dreadnought.Sprites.t
    field :duration, number()
    #field :fade_duration, number(), default: 0
  end

  # *** *******************************
  # *** NEW

  def new(sprite, duration \\ 1) do
    fields = [
      sprite: sprite,
      duration: duration
    ]
    struct!(__MODULE__, fields)
  end

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Chukinas.Dreadnought.AnimationFrame

defimpl Inspect, for: AnimationFrame do
  require IOP
  def inspect(animation_frame, opts) do
    title = "AnimationFrame"
    fields = [
      sprite: animation_frame.sprite.name
    ]
    IOP.struct(title, fields)
  end
end

defimpl Chukinas.BoundingRect, for: AnimationFrame do
  def of(%AnimationFrame{sprite: sprite}) do
    Chukinas.BoundingRect.of(sprite)
  end
end
