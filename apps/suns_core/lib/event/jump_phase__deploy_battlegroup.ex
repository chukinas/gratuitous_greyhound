defmodule SunsCore.Event.JumpPhase.DeployBattlegroup do

  use Spatial, :pos
  use SunsCore.Event, :impl
  alias SunsCore.Mission.Battlegroup
  alias SunsCore.Mission.JumpPoint
  alias SunsCore.Mission.Ship
  alias SunsCore.Mission.Table
  alias SunsCore.Space.TablePose
  alias SunsCore.Space
  alias Util.IdList

  # *** *******************************
  # *** TYPES

  event_struct do
    field :jump_point_id, pos_integer
    field :poses, [Pose.t]
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(jump_point_id, poses) do
    %__MODULE__{
      jump_point_id: jump_point_id,
      poses: poses
    }
  end

  # *** *******************************
  # *** CALLBACKS

  # TODO check that not within 10" of planetoid

  def validity_check(%__MODULE__{jump_point_id: jump_point_id, poses: poses}, snapshot) do
    battlegroup =
      snapshot
      |> S.battlegroups
      |> Battlegroup.from_list_undeployed
    first_ship_id =
      snapshot
      |> S.ships
      |> IdList.next_id
    ship_ids =
      first_ship_id..(first_ship_id + Battlegroup.starting_count(battlegroup) - 1)
    class_name =
      Battlegroup.class_name(battlegroup)
    jump_point =
      snapshot
      |> S.jump_point_by_id(jump_point_id)
    table_id =
      Space.table_id(jump_point)
    ships =
      for {id, pose} <- Enum.zip(ship_ids, poses) do
        table_pose = TablePose.from_pose(table_id, pose)
        Ship.new(id, Battlegroup.id(battlegroup), class_name, table_pose)
      end
    table = S.table_by_id(snapshot, table_id)
    with :ok <- JumpPoint.check_ships_are_within(jump_point, ships),
         :ok <- Table.check_contains_points(table, ships),
         :ok <- Space.check_contiguous(ships) do
      {:ok, %{battlegroup: battlegroup, ships: ships}}
    else
      {:error, _reason} = error_tuple -> error_tuple
    end
  end

  def execute(_event, snapshot, %{battlegroup: battlegroup, ships: ships}) do
    snapshot
    |> S.overwrite!(battlegroup)
    |> S.put_new(ships)
  end

end
