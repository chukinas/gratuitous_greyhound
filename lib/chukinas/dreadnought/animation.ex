alias Chukinas.Dreadnought.{Animation, Spritesheet}
alias Chukinas.Geometry.{Rect, Pose}

defmodule Animation do
  alias Animation.Frame

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enfore: true do
    field :id_string, String.t()
    field :name, String.t()
    field :pose, Pose.t()
    field :delay, number()
    field :frames, [Frame.t()], default: []
    field :last_frame_fade_duration, number(), default: 0
    # number of times to repeat. -1 means infinite loop
    field :repeat, number(), default: 1
  end

  # *** *******************************
  # *** NEW

  def new(name, %Pose{} = pose, delay \\ 0) when is_number(delay) do
    fields = [
      id_string: "animation-frame-#{Enum.random(1..10_000)}",
      name: name,
      pose: pose,
      delay: delay,
    ]
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  def bounding_rect(%__MODULE__{frames: frames}) do
    frames
    |> Enum.map(&Frame.rect/1)
    |> Rect.bounding_rect
  end

  # *** *******************************
  # *** SETTERS

  def put(%__MODULE__{} = animation, %Frame{} = frame) do
    #frame = Frame.fade(frame, animation.last_frame_fade_duration)
    frames =
      animation.frames
      #|> Enum.map(&Frame.remove_fade/1)
      |> Enum.concat(List.wrap(frame))
    %__MODULE__{animation | frames: frames}
    |> IOP.inspect("Animation put")
  end

  def put_frame(animation, sprite_fun, sprite_name, duration) when is_number(duration) do
    sprite = apply(Spritesheet, sprite_fun, [sprite_name])
    frame = Frame.new(sprite, duration)
    put(animation, frame)
  end

  def fade(animation, duration \\ 0.5) do
    %__MODULE__{animation | last_frame_fade_duration: duration}
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
        pose: animation.pose,
        frames: animation.frames
      ]
      IOP.struct(title, fields)
    end
  end
end
