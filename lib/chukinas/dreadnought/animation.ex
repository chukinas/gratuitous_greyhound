alias Chukinas.Dreadnought.{Animation, Spritesheet}
alias Chukinas.Geometry.{Rect, Pose}
alias Chukinas.Util.Maps

defmodule Animation do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enfore: true do
    field :id_string, String.t()
    field :name, String.t()
    field :pose, Pose.t()
    # TODO rename delay
    field :start, number()
    field :frames, [Animation.Frame.t()], default: []
    # number of times to repeat. -1 means infinite loop
    field :repeat, number(), default: 1
  end

  # *** *******************************
  # *** NEW

  def new(name, %Pose{} = pose, start, opts \\ []) when is_number(start) do
    fields = Keyword.merge(opts,
      name: name,
      pose: pose,
      start: start,
      id_string: "animation-frame-#{Enum.random(1..10_000)}"
    )
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  def bounding_rect(%__MODULE__{frames: frames}) do
    frames
    |> Enum.map(&Animation.Frame.rect/1)
    |> Rect.bounding_rect
  end

  # *** *******************************
  # *** SETTERS

  def put(%__MODULE__{} = animation, %Animation.Frame{} = frame) do
    Maps.push(animation, :frames, frame)
  end

  def put_frame(animation, sprite_fun, sprite_name, delay, fade_duration) do
    sprite = apply(Spritesheet, sprite_fun, [sprite_name])
    frame = Animation.Frame.new(sprite, start: delay, fade_duration: fade_duration)
    put(animation, frame)
  end

  # *** *******************************
  # *** TRANSFORM

  def repeat(animation) do
    %__MODULE__{animation | repeat: -1}
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    require IOP
    def inspect(animation, opts) do
      title = "Animation"
      fields = [
        name: animation.name,
        pose: animation.pose
      ]
      IOP.struct(title, fields)
    end
  end
end
