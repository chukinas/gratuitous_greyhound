defmodule Chukinas.Dreadnought.AnimationFrame do

  alias Chukinas.Geometry.Rect

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

  # *** *******************************
  # *** GETTERS

  def rect(%__MODULE__{sprite: sprite}) do
    Rect.new(sprite)
  end

  # *** *******************************
  # *** SETTERS

  #def fade(frame, duration \\ 0.5) do
  #  %__MODULE__{frame | fade_duration: duration}
  #end

  # *** *******************************
  # *** TRANSFORM

  #def remove_fade(frame) do
  #  %__MODULE__{frame | fade_duration: 0}
  #end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    require IOP
    def inspect(animation_frame, opts) do
      title = "AnimationFrame"
      fields = [
        sprite: animation_frame.sprite.name
      ]
      IOP.struct(title, fields)
    end
  end
end
