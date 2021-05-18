alias Chukinas.Dreadnought.{Animation, Sprite}

defmodule Animation.Frame do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enfore: true do
    field :sprite, Sprite.t()
    # TODO rename delay
    field :start, number(), default: 0
    field :fade_duration, number() | :nofade, default: :nofade
  end

  # *** *******************************
  # *** NEW

  def new(sprite, opts \\ []) do
    fields = Keyword.merge(opts,
      sprite: sprite
    )
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  def rect(%__MODULE__{sprite: sprite}) do
    Sprite.rect(sprite)
  end

  # *** *******************************
  # *** SETTERS

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
