defmodule SunsCore.Space.TablePose do

  use CollisionDetection.CollidableImpl, :map_to_point
  use Spatial.LinearAlgebra
  use Spatial.PositionOrientationSize
  alias SunsCore.Mission.Weapon.RangeAndArc

  use TypedStruct
  typedstruct enforce: true do
    field :table_id, pos_integer
    field :x, number
    field :y, number
    field :angle, number
  end

  # *** *******************************
  # *** CONSTRUCTORS

  # TODO these guards aren't necessary
  @spec new(pos_integer, number, number, number) :: t
  def new(table_id, x, y, angle \\ 0)
  when is_integer(table_id)
  and is_number(x)
  and is_number(y)
  and is_number(angle) do
    %__MODULE__{
      table_id: table_id,
      x: x,
      y: y,
      angle: angle
    }
  end

  # TODO used?
  @spec from_pose(pos_integer, Pose.t) :: t
  def from_pose(table_id, %Pose{x: x, y: y, angle: angle}) do
    new(table_id, x, y, angle)
  end

  # *** *******************************
  # *** CONVERTERS

  # TODO private?
  def in_arc?(observer, subject, arc)
  when has_pose(observer)
  and has_position(subject)
  and is_integer(arc) do
    observer_csys = csys_from_pose(observer)
    subject
    |> vector_from_position
    |> vector_wrt_inner_observer(observer_csys)
    |> vector_to_angle
    |> abs
    |> Kernel.<=(arc / 2)
  end

  @spec in_range_and_fire_arc?(t, [t], RangeAndArc.t) :: boolean
  def in_range_and_fire_arc?(attacker, targets, %RangeAndArc{} = range_and_arc) do
    targets
    |> Stream.filter(&target_in_range?(attacker, &1, range_and_arc))
    |> Enum.any?(&in_fire_arc?(attacker, &1, range_and_arc))
  end

  # *** *******************************
  # *** CONVERTERS (private)

  @spec target_in_range?(t, t, RangeAndArc.t) :: boolean
  defp target_in_range?(attacker, target, %RangeAndArc{range_min: min, range_max: max}) do
    range = distance_between(attacker, target)
    min <= range && range <= max
  end

  @spec in_fire_arc?(t, t, RangeAndArc.t) :: boolean
  defp in_fire_arc?(attacker, target, %{arc: arc}) do
    in_arc?(attacker, target, arc)
  end

  def table_id(%__MODULE__{table_id: value}), do: value

  def distance_between(observer, subject)
  when has_position(observer)
  and has_position(subject) do
    observer_vector = vector_from_position(observer)
    subject_vector = vector_from_position(subject)
    observer_vector
    |> vector_subtract(subject_vector)
    |> vector_to_magnitude
  end

  def subject_in_range?(observer, subject, max_range)
  when has_position(observer)
  and has_position(subject) do
    distance_between(observer, subject) <= max_range
  end

  def all_subjects_in_range?(observer, subjects, max_range)
  when has_position(observer)
  and is_list(subjects)
  and is_integer(max_range) do
    Enum.all?(subjects, &subject_in_range?(observer, &1, max_range))
  end

  def any_subjects_in_range?(observer, subjects, max_range)
  when has_position(observer)
  and is_list(subjects)
  and is_integer(max_range) do
    Enum.any?(subjects, &subject_in_range?(observer, &1, max_range))
  end


end
