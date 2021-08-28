defmodule SunsCore.Event.Setup.AddObjective do

  use SunsCore.Event, :impl
  alias SunsCore.Mission.Contract
  alias SunsCore.Mission.Objective

  # *** *******************************
  # *** TYPES

  event_struct do
    field :objective, Objective.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(Objective.t) :: t
  def new(objective) do
    %__MODULE__{
      objective: objective
    }
  end

  # *** *******************************
  # *** CONVERTERS

  def objective(%__MODULE__{objective: objective}, snapshot) do
    Objective.set_id(objective, S.next_id(snapshot, :objectives))
  end

  def we_have_enough_objectives?(_ev, snapshot) do
    snapshot
    |> S.contracts
    |> Contract.Collection.all_objectives_set_up?(snapshot |> S.objectives)
  end

  # *** *******************************
  # *** CALLBACKS

  @impl Event
  def action(ev, snapshot) do
    snapshot
    |> S.put_new(objective(ev, snapshot))
    |> ok
  end

  @impl Event
  def post_guard(ev, snapshot) do
    if we_have_enough_objectives?(ev, snapshot) do
      :ok
    else
      :stay
    end
  end

end
