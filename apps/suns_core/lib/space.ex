defmodule SunsCore.Space do
  @moduledoc """
  Helpers for working with positions, line of site, range, etc.
  """

  use Spatial.LinearAlgebra
  use Spatial, :pos
  alias SunsCore.Space.Poseable
  alias SunsCore.Space.TablePose
  alias Util.Response

  # *** *******************************
  # *** TYPES

  @type table_pose :: TablePose.t

  # *** *******************************
  # *** API, gathered from other places

  def new_position(x, y), do: position_new(x, y)
  def new_pose(x, y, angle), do: pose_new(x, y, angle)

  # *** *******************************
  # *** API

  defdelegate in_arc?(observer, subject, arc), to: TablePose

  @spec check_contiguous(any) :: Response.t
  def check_contiguous(_ships) do
    # TODO implement
    true
    |> Response.from_bool("Battlegroup is not in contiguous formation")
  end

  # TODO is this module even needed now that TablePose takes over for TablePosition?
  def table_id(item) do
    case Poseable.table_pose(item) do
      %TablePose{table_id: table_id} -> table_id
    end
  end

  def table_id_is?(item, table_id) do
    table_id(item) == table_id
  end

  # *** *******************************
  # *** Position API

  def observer_within_range_of_all_subjects(obs, subs, range) do
    TablePose.all_subjects_in_range?(obs, subs, range)
  end

end
