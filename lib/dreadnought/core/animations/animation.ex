defmodule Dreadnought.Core.Animation do

    use Dreadnought.PositionOrientationSize
    use Dreadnought.TypedStruct
  alias Dreadnought.Core.AnimationFrame
  alias Dreadnought.Sprite

  # *** *******************************
  # *** TYPES

  @categories ~w/muzzle_flash hit/a
  @type categories :: :muzzle_flash | :hit

  typedstruct enfore: true do
    pose_fields()
    field :id_string, String.t()
    field :name, String.t()
    field :delay, number()
    field :frames, [AnimationFrame.t()], default: []
    field :last_frame_fade_duration, number(), default: 0
    # number of times to repeat. -1 means infinite loop
    field :repeat, number(), default: 0
    field :category, categories
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(name, category, pose, delay \\ 0)
  when has_pose(pose)
  and is_number(delay)
  and category in @categories do
    fields =
      %{
        id_string: "animation-frame-#{Enum.random(1..10_000)}",
        name: name,
        delay: delay,
        category: category
      }
      |> merge_pose(pose)
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** REDUCERS

  def fade(animation, duration \\ 0.5) do
    %__MODULE__{animation | last_frame_fade_duration: duration}
  end

  def put(%__MODULE__{} = animation, %AnimationFrame{} = frame) do
    #frame = AnimationFrame.fade(frame, animation.last_frame_fade_duration)
    frames =
      animation.frames
      #|> Enum.map(&AnimationFrame.remove_fade/1)
      |> Enum.concat(List.wrap(frame))
    %__MODULE__{animation | frames: frames}
  end

  def put_frame(animation, sprite_fun, sprite_name, duration) when is_number(duration) do
    sprite_spec = Sprite.Spec.new(sprite_fun, sprite_name)
    sprite = Sprite.Builder.build(sprite_spec)
    frame = AnimationFrame.new(sprite, duration)
    put(animation, frame)
  end

  def repeat(animation) do
    %__MODULE__{animation | repeat: -1}
  end

  # *** *******************************
  # *** CONVERTERS

  def muzzle_flash?(%__MODULE__{category: category}), do: category == :muzzle_flash

end

# *** *******************************
# *** IMPLEMENTATIONS

alias Dreadnought.Core.Animation

defimpl Inspect, for: Animation do
  require IOP
  use Dreadnought.PositionOrientationSize
  def inspect(animation, opts) do
    title = "Animation"
    fields = [
      name: animation.name,
      pose: animation |> pose_from_map,
      frames: animation.frames
    ]
    IOP.struct(title, fields)
  end
end

defimpl Dreadnought.BoundingRect, for: Animation do
  def of(%Animation{frames: frames}) do
    Dreadnought.BoundingRect.of(frames)
  end
end
