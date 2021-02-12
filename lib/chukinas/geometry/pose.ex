defmodule Chukinas.Geometry.Pose do

  use TypedStruct

  typedstruct enforce: true do
    field :x, number()
    field :y, number()
    field :angle, number()
  end

  # *** *******************************
  # *** NEW

  def new(x, y, angle) do
    %__MODULE__{
      x: x,
      y: y,
      angle: angle,
    }
  end

  # *** *******************************
  # *** API

  # TODO move this to POsition
  def position_to_tuple(pose) do
    {pose.x, pose.y}
  end
end
