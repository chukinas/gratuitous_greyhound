defmodule Chukinas.Geometry.Path.Straight do
  alias Chukinas.Geometry.Pose

  use TypedStruct

  typedstruct enforce: true do
    field :start, Pose.t()
    field :len, number()
  end

  # *** *******************************
  # *** NEW

  def new(start_pose, len) do
    %__MODULE__{
      start: start_pose,
      len: len,
    }
  end
  def new(x, y, angle, len) do
    %__MODULE__{
      start: Pose.new(x, y, angle),
      len: len,
    }
  end
end
