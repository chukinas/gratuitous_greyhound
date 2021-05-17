alias Chukinas.Dreadnought.{Animation}
alias Chukinas.Geometry.Pose

defmodule Animation do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enfore: true do
    field :pose, Pose.t()
    field :start, number()
    field :frames, [Animation.Frame.t()], default: []
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
