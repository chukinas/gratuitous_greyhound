defmodule Chukinas.Geometry.Path.Turn do
  alias Chukinas.Geometry.Pose

  use TypedStruct

  typedstruct enforce: true do
    field :start, Pose.t()
    field :len, number()
    field :angle, integer()
  end

  # *** *******************************
  # *** NEW

  def new(start_pose, len, angle) do
    %__MODULE__{
      start: start_pose,
      len: len,
      angle: angle,
    }
  end
  def new(x, y, angle, len, angle) do
    %__MODULE__{
      start: Pose.new(x, y, angle),
      len: len,
      angle: angle,
    }
  end
end
