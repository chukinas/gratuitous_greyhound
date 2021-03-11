alias Chukinas.Dreadnought.{Unit, Segment, ById}
alias Chukinas.Geometry.{Pose}

defmodule Unit do
  @moduledoc """
  Represents a ship or some other combat unit
  """

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

  def new(id, opts \\ []) do
    fields =
      # TODO I don't like having a default start pose. Make it explicit.
      [start_pose: Pose.new(0, 0, 45)]
      |> Keyword.merge(opts)
      |> Keyword.put(:id, id)
    struct(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  def id(unit), do: unit.id
  def start_pose(unit), do: unit.start_pose
  def segment(unit, id), do: unit.segments |> ById.get(id)

  # *** *******************************
  # *** API

  def set_segments(unit, segments) do
    %{unit | segments: segments}
  end
end
