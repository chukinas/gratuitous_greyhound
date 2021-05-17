alias Chukinas.Dreadnought.{Animation}
alias Chukinas.Geometry.Pose
alias Chukinas.Util.Maps

defmodule Animation do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enfore: true do
    field :name, String.t()
    field :pose, Pose.t()
    field :start, number()
    field :frames, [Animation.Frame.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(name, %Pose{} = pose, start, opts \\ []) when is_number(start) do
    fields = Keyword.merge(opts,
      name: name,
      pose: pose,
      start: start
    )
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  # *** *******************************
  # *** SETTERS

  def put(%__MODULE__{} = animation, %Animation.Frame{} = frame) do
    Maps.push(animation, :frames, frame)
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
