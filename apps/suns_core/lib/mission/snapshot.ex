# TODO this this maybe be called Mission? MissionContext?

defmodule SunsCore.Mission.Snapshot do

  alias SunsCore.Mission.Battlegroup
  alias SunsCore.Mission.Contract
  alias SunsCore.Mission.Helm
  alias SunsCore.Mission.JumpPoint
  alias SunsCore.Mission.Objective
  alias SunsCore.Mission.Ship
  alias SunsCore.Mission.Table
  alias SunsCore.Space
  alias Util.IdList

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :administrator, :system | pos_integer, enforce: false
    field :battlegroups, [Battlegroup.t], default: []
    field :helms, [Helm.t], default: []
    field :jump_points, [JumpPoint.t], default: []
    field :objectives, [Objective.t], default: []
    field :scale, pos_integer, enforce: false
    field :ships, [Ship.t], default: []
    field :tables, [Table.t], default: []
    field :turn_number, pos_integer, default: 0
    field :contracts, [Contract.t], default: [Contract.Builder.BasicTraining.demolition()]
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new do
    %__MODULE__{}
  end

  # *** *******************************
  # *** REDUCERS

  def overwrite!(%__MODULE__{} = snapshot, model) do
    Map.update!(snapshot, _key(model), &IdList.overwrite!(&1, model))
  end

  def put_new(%__MODULE__{} = snapshot, models) when is_list(models) do
    Enum.reduce(models, snapshot, &put_new(&2, &1))
  end

  def put_new(%__MODULE__{} = snapshot, model) do
    Map.update!(snapshot, _key(model), &IdList.put(&1, model))
  end

  def incr_turn_number(%__MODULE__{} = snapshot) do
    Map.update!(snapshot, :turn_number, fn tn -> tn + 1 end)
  end

  # *** *******************************
  # *** CONVERTERS

  def get(%__MODULE__{} = snapshot, key), do: Map.fetch!(snapshot, key)

  def battlegroup_by_id(%__MODULE__{battlegroups: value}, id), do: value |> IdList.fetch!(id)
  def helm_by_id(%__MODULE__{helms: value}, id), do: value |> IdList.fetch!(id)
  def jump_point_by_id(%__MODULE__{jump_points: value}, id), do: value |> IdList.fetch!(id)
  def ship_by_id(%__MODULE__{ships: value}, id), do: value |> IdList.fetch!(id)
  def table_by_id(%__MODULE__{tables: value}, id), do: value |> IdList.fetch!(id)

  def ships_by_table_id(snapshot, table_id) do
    snapshot
    |> ships
    |> Enum.filter(&Space.table_id_is?(&1, table_id))
  end

  # *** *******************************
  # *** HELPERS

  defp _key(%Battlegroup{}), do: :battlegroups
  defp _key(%Helm{}), do: :helms
  defp _key(%JumpPoint{}), do: :jump_points
  defp _key(%Ship{}), do: :ships
  defp _key(%Table{}), do: :tables
  defp _key(objective) when is_struct(objective) do
    # TODO temp hack
    Objective.contract_type(objective)
    :objectives
  end

  def next_id(%__MODULE__{} = context, key) do
    context
    |> Map.fetch!(key)
    |> IdList.next_id
  end

end
