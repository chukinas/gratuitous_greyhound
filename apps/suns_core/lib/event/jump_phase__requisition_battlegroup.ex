defmodule SunsCore.Event.JumpPhase.RequisitionBattlegroup do

  use SunsCore.Event, :impl
  alias SunsCore.Mission.Battlegroup
  alias SunsCore.Mission.Helm
  alias Util.IdList

  # *** *******************************
  # *** TYPES

  event_struct do
    field :battlegroup, Battlegroup.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(player_id, type, count) do
    %__MODULE__{
      battlegroup: Battlegroup.new(player_id, type, count)
    }
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  @impl Event
  def action(
    %__MODULE__{battlegroup: battlegroup},
    %S{helms: helms, battlegroups: battlegroups} = snapshot
  ) do
    battlegroup = Battlegroup.set_id(battlegroup, IdList.next_id(battlegroups))
    cost = Battlegroup.cost(battlegroup)
    helm =
      helms
      |> IdList.fetch!(battlegroup.player_id)
      |> Helm.spend_credits(cost)
      |> Helm.spend_cmd(:jump)
    snapshot
    |> S.overwrite!(helm)
    |> S.put_new(battlegroup)
  end

end
