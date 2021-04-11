defmodule Chukinas.Dreadnought.Sprite do

  use TypedStruct

  typedstruct do
    field :id, integer()
    field :pose, Pose.t()
    field :maneuver_svg_string, String.t()
  end
end
