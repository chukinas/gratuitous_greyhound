defmodule Chukinas.Dreadnought.Animation do

  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.AnimationFrame
  alias Chukinas.Dreadnought.Sprites
  alias Chukinas.Geometry.Rect

  # *** *******************************
  # *** TYPES

  typedstruct enfore: true do
    field :id_string, String.t()
    field :name, String.t()
    pose_fields()
    field :delay, number()
    field :frames, [AnimationFrame.t()], default: []
    field :last_frame_fade_duration, number(), default: 0
    # number of times to repeat. -1 means infinite loop
    field :repeat, number(), default: 0
  end

  # *** *******************************
  # *** NEW

  def new(name, pose, delay \\ 0) when has_pose(pose) and is_number(delay) do
    fields =
      %{
        id_string: "animation-frame-#{Enum.random(1..10_000)}",
        name: name,
        delay: delay,
      }
      |> merge_pose(pose)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  def bounding_rect(%__MODULE__{frames: frames}) do
    frames
    |> Enum.map(&AnimationFrame.rect/1)
    |> Rect.bounding_rect
  end

  # *** *******************************
  # *** SETTERS

  def put(%__MODULE__{} = animation, %AnimationFrame{} = frame) do
    #frame = AnimationFrame.fade(frame, animation.last_frame_fade_duration)
    frames =
      animation.frames
      #|> Enum.map(&AnimationFrame.remove_fade/1)
      |> Enum.concat(List.wrap(frame))
    %__MODULE__{animation | frames: frames}
  end

  def put_frame(animation, sprite_fun, sprite_name, duration) when is_number(duration) do
    sprite = apply(Sprites, sprite_fun, [sprite_name])
    frame = AnimationFrame.new(sprite, duration)
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
    import Chukinas.PositionOrientationSize
    def inspect(animation, opts) do
      title = "Animation"
      fields = [
        name: animation.name,
        pose: animation |> pose_new,
        frames: animation.frames
      ]
      IOP.struct(title, fields)
    end
  end
end
