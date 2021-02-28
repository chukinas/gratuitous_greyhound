alias Chukinas.Dreadnought.{Unit, Segment, Guards}
alias Chukinas.Geometry.{Pose}

defmodule Unit do
  @moduledoc """
  Represents a ship or some other combat unit
  """

  import Guards

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    # ID must be unique within the world
    field :id, integer()
    field :start_pose, Pose.t()
    field :segments, [Segment.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(id) do
    start_pose = Pose.new(0, 0, 45)
    %__MODULE__{
      id: id,
      start_pose: start_pose,
    }
  end

  # *** *******************************
  # *** GETTERS

  def id(unit), do: unit.id
  def start_pose(unit), do: unit.start_pose
  def segment(unit, id), do: unit.segments |> get_by_id(id)

  # *** *******************************
  # *** API

  def set_segments(unit, segments) do
    %{unit | segments: segments}
  end
end
