alias Chukinas.Dreadnought.{AnimationFrame, Sprite}

defmodule AnimationFrame do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enfore: true do
    field :sprite, Sprite.t()
    field :fr, number(), default: 1
    field :fade?, boolean(), default: false
    field :fade_duration, number(), enforce: false
  end

  # *** *******************************
  # *** NEW

  def new(sprite, opts \\ []) do
    fields = Keyword.put(opts, :sprite, sprite)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

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
