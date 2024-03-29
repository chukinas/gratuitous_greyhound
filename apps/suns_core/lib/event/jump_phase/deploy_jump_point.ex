defmodule SunsCore.Event.JumpPhase.DeployJumpPoint do

  use SunsCore.Event, :impl
  alias SunsCore.Mission.Helm
  alias SunsCore.Mission.JumpPoint
  alias SunsCore.Space.TablePose
  alias Util.IdList

  # *** *******************************
  # *** TYPES

  event_struct do
    field :player_id, pos_integer
    field :table_pose, TablePose.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(pos_integer, TablePose.t) :: t
  def new(player_id, %TablePose{} = table_pose) do
    %__MODULE__{
      player_id: player_id,
      table_pose: table_pose
    }
  end

  # *** *******************************
  # *** CONVERTERS

  def table_pose(%__MODULE__{table_pose: value}), do: value
  def player_id(%__MODULE__{player_id: value}), do: value

  def build_jump_point(event, snapshot) do
    JumpPoint.new(
      snapshot |> S.jump_points |> IdList.next_id,
      player_id(event),
      table_pose(event),
      S.turn_number(snapshot)
    )
  end

  def helm(ev, snapshot) do
    snapshot
    |> S.helm_by_id(ev |> player_id)
  end

  def avail_jump_command?(ev, snapshot) do
    helm(ev, snapshot)
    |> Helm.has_jump_cmd?
  end

  def helm_after_spendin_jump_cmd(ev, snapshop) do
    helm(ev, snapshop) |> Helm.spend_cmd(:jump)
  end

  # *** *******************************
  # *** CALLBACKS

  @impl Event
  def guard(ev, snapshot) do
    if avail_jump_command?(ev, snapshot) do
      :ok
    else
      {:error, "No available jump event points"}
    end
  end

  @impl Event
  def action(ev, snapshot) do
    snapshot
    |> S.overwrite!(helm_after_spendin_jump_cmd(ev, snapshot))
    |> S.put_new(build_jump_point(ev, snapshot))
  end

end
