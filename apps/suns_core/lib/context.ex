defmodule SunsCore.Context do

  alias SunsCore.Mission.Battlegroup
  alias SunsCore.Mission.Contract
  alias SunsCore.Mission.GlobalId
  alias SunsCore.Mission.Helm
  alias SunsCore.Mission.JumpPoint
  alias SunsCore.Mission.Object
  alias SunsCore.Mission.Order
  alias SunsCore.Mission.Ship
  alias SunsCore.Mission.Subcontext
  alias SunsCore.Mission.Subcontext.Collection, as: Subcontexts
  alias SunsCore.Mission.Table
  alias SunsCore.Mission.PlayerOrderTracker
  alias SunsCore.Space
  alias Util.IdList

  # *** *******************************
  # *** TYPES

  @global_ids [
    battlegroup: :battlegroups,
    object: :objects,
    ship: :ships
  ]

  use Util.GetterStruct
  getter_struct do
    field :administrator, :system | pos_integer, enforce: false
    field :current_order, [Order.t], enforce: false
    field :scale, pos_integer, enforce: false
    field :subcontexts, Subcontexts.t, default: Subcontexts.new()
    # TODO delete
    field :turn_order_tracker, PlayerOrderTracker.t, enforce: false
    field :turn_number, pos_integer, default: 0
    # IdLists
    field :battlegroups, [Battlegroup.t], default: []
    field :contracts, [Contract.t], default: [Contract.Builder.BasicTraining.demolition()]
    field :helms, [Helm.t], default: []
    field :jump_points, [JumpPoint.t], default: []
    field :objects, [Object.t], default: []
    field :ships, [Ship.t], default: []
    field :tables, [Table.t], default: []
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new do
    %__MODULE__{}
  end

  # *** *******************************
  # *** REDUCERS

  def clear_subcontext(%__MODULE__{} = ctx, module) do
    subcontexts =
      ctx
      |> subcontexts
      |> Subcontexts.delete(module)
    struct!(ctx, subcontexts: subcontexts)
  end

  # I could have better terminology for this...
  # overwrite puts an item into a list
  # set/2 overwrites the value entirely (like for PlayerOrderTracker)
  def overwrite!(%__MODULE__{} = cxt, items) when is_list(items) do
    Enum.reduce(items, cxt, &overwrite!(&2, &1))
  end
  def overwrite!(%__MODULE__{} = snapshot, model) do
    Map.update!(snapshot, _key(model), &IdList.overwrite!(&1, model))
  end

  def put_new(%__MODULE__{} = snapshot, models) when is_list(models) do
    Enum.reduce(models, snapshot, &put_new(&2, &1))
  end

  def put_new(%__MODULE__{subcontexts: subcontexts} = ctx, model) do
    cond do
      Subcontext.impl?(model) && not Subcontexts.has?(subcontexts, model) ->
        struct!(ctx, subcontexts: Subcontexts.put(subcontexts, model))
      true ->
        Map.update!(ctx, _key(model), &IdList.put(&1, model))
    end
  end

  def incr_turn_number(%__MODULE__{} = snapshot) do
    Map.update!(snapshot, :turn_number, fn tn -> tn + 1 end)
  end

  def set(%__MODULE__{} = cxt, %PlayerOrderTracker{} = tot) do
    %{cxt | turn_order_tracker: tot}
  end

  def set(%__MODULE__{} = ctx, item) do
    if Subcontext.impl?(item) do
      Map.update!(ctx, :subcontexts, &Subcontexts.put(&1, item))
    else
      raise "no matching subcontext!"
    end
  end

  # *** *******************************
  # *** CONVERTERS

  @spec fetch_subcontext!(t, module | Subcontext.t) :: Subcontext.t
  def fetch_subcontext!(%__MODULE__{subcontexts: subcontexts}, module_or_struct) do
    Subcontexts.fetch!(subcontexts, module_or_struct)
  end

  def get(%__MODULE__{} = snapshot, key), do: Map.fetch!(snapshot, key)

  def helm_by_id(%__MODULE__{helms: value}, id), do: value |> IdList.fetch!(id)
  def jump_point_by_id(%__MODULE__{jump_points: value}, id), do: value |> IdList.fetch!(id)
  def ship_by_id(%__MODULE__{ships: value}, id), do: value |> IdList.fetch!(id)
  def table_by_id(%__MODULE__{tables: value}, id), do: value |> IdList.fetch!(id)

  def ships_by_table_id(snapshot, table_id) do
    snapshot
    |> ships
    |> Enum.filter(&Space.table_id_is?(&1, table_id))
  end

  def player_count(cxt) do
    cxt
    |> helms
    |> Enum.count
  end

  @spec fetch_by_global_id!(t, GlobalId.t) :: any
  for {global_id_symbol, field_name} <- @global_ids do
    def fetch_by_global_id!(context, {unquote(global_id_symbol), id})
    when is_integer(id) do
      context
      |> unquote(field_name)()
      |> IdList.fetch!(id)
    end
  end

  # *** *******************************
  # *** HELPERS

  defp _key(struct) do
    case struct do
      %Battlegroup{} -> :battlegroups
      %Helm{} -> :helms
      %Object{} -> :objects
      %Ship{} -> :ships
      %Table{} -> :tables
    end
  end

  def next_id(%__MODULE__{} = context, key) do
    context
    |> Map.fetch!(key)
    |> IdList.next_id
  end

end
