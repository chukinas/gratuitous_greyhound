defmodule Dreadnought.Core.AnimationFrame do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enfore: true do
    field :sprite, Dreadnought.Sprite.t
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

# *** *********************************
# *** IMPLEMENTATIONS
# *** *********************************

alias Dreadnought.Core.AnimationFrame

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

defimpl Dreadnought.BoundingRect, for: AnimationFrame do
  def of(%AnimationFrame{sprite: sprite}) do
    Dreadnought.BoundingRect.of(sprite)
  end
end
