defmodule SunsCore.Space do
  @moduledoc """
  Helpers for working with positions, line of site, range, etc.
  """

  use Spatial.LinearAlgebra
  use Spatial, :pos
  alias SunsCore.Mission.HasTablePosition
  alias SunsCore.Space.TablePose
  alias SunsCore.Space.TablePosition
  alias Util.Response

  # *** *******************************
  # *** API, gathered from other places

  def new_pose(x, y, angle), do: pose_new(x, y, angle)
  defdelegate new_table_position(table_id, x, y), to: TablePosition, as: :new

  # *** *******************************
  # *** API

  @doc """
  True if subect(s) are all within range of and on same table as target
  """
  @spec check_within(HasTablePosition.t, HasTablePosition.t | [HasTablePosition.t], pos_integer)
    :: Response.t
  def check_within(target, subjects, range) when is_list(subjects) do
    target_vector = vector(target)
    Enum.all?(subjects, fn subject ->
      distance =
        subject
        |> vector
        |> do_distance_between(target_vector)
      same_table?(target, subject) && distance <= range
    end)
    |> Response.from_bool("Subjects (#{subjects}) are not within range of target (#{target})")
  end

  def within?(target, subject, range) do
    target_vector = vector(target)
    distance =
      subject
      |> vector
      |> do_distance_between(target_vector)
    (same_table?(target, subject) && distance <= range)
    |> Response.from_bool("Subject (#{subject}) is not within range of target (#{target})")
  end

  @spec check_within_table_shape(any, any) :: Response.t
  def check_within_table_shape(_table, _subject) do
    # TODO implement
    true
    |> Response.from_bool("Subject is outside the table's boundary")
  end

  @spec check_contiguous(any) :: Response.t
  def check_contiguous(_ships) do
    # TODO implement
    true
    |> Response.from_bool("Battlegroup is not in contiguous formation")
  end

  def table_id(item) do
    case HasTablePosition.table_position(item) do
      %TablePosition{table_id: table_id} -> table_id
      %TablePose{table_id: table_id} -> table_id
    end
  end

  def table_id_is?(item, table_id) do
    table_id(item) == table_id
  end

  # *** *******************************
  # *** PRIVATE

  defp do_distance_between(target_vector, subject_vector)
  when is_vector(target_vector)
  and is_vector(subject_vector) do
    target_vector
    |> vector_subtract(subject_vector)
    |> vector_to_magnitude
  end

  defp vector(item) do
    case HasTablePosition.table_position(item) do
      %TablePosition{x: x, y: y} -> vector_new(x, y)
      %TablePose{x: x, y: y} -> vector_new(x, y)
    end
  end

  defp same_table?(target, subject) do
    table_id(target) == table_id(subject)
  end

end