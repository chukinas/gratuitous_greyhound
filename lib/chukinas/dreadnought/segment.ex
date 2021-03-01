alias Chukinas.Dreadnought.{Segment}
alias Chukinas.Svg
alias Chukinas.Geometry.{Pose, Path}

defmodule Segment do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :unit_id, integer()
    field :step_id, integer()
    field :start_pose, Pose.t()
    field :end_pose, Pose.t()
    field :svg_path, String.t()
  end

  # *** *******************************
  # *** NEW

  def new(path, unit_id, step_id) do
    %__MODULE__{
      unit_id: unit_id,
      step_id: step_id,
      start_pose: Path.get_start_pose(path),
      end_pose: Path.get_end_pose(path),
      svg_path: Svg.get_path_string(path),
    }
  end

  # *** *******************************
  # *** GETTERS

  def id(%__MODULE__{unit_id: unit_id, step_id: step_id}), do: {unit_id, step_id}
  def start_pose(segment), do: segment.start_pose
  def end_pose(segment), do: segment.end_pose
  def svg_path(segment), do: segment.svg_path

  # *** *******************************
  # *** BOOLEAN

  def match?(%__MODULE__{} = segment, unit_id, step_id) do
    id(segment) == {unit_id, step_id}
  end
end
