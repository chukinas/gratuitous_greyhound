defmodule Chukinas.Geometry.Path.Turn do
  alias Chukinas.Geometry.Pose

  use TypedStruct

  typedstruct enforce: true do
    field :pose, Pose.t()
    field :length, number()
    field :angle, integer()
  end

  # *** *******************************
  # *** NEW

  def new(%Pose{} = start_pose, len, angle) do
    %__MODULE__{
      pose: start_pose,
      length: len,
      angle: angle,
    }
  end
  def new(x, y, angle, len, angle) do
    %__MODULE__{
      pose: Pose.new(x, y, angle),
      length: len,
      angle: angle,
    }
  end
end
