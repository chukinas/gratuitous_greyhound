defmodule SunsCore.Event.Setup.AddObjective do

  use SunsCore.Event, :impl
  alias SunsCore.Mission.Contract
  alias SunsCore.Mission.Object

  # *** *******************************
  # *** TYPES

  event_struct do
    field :objective, Object.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(Object.t) :: t
  def new(object) do
    %__MODULE__{
      objective: object
    }
  end

  # *** *******************************
  # *** CONVERTERS

  def objective(%__MODULE__{objective: objective}, snapshot) do
    Object.set_id(objective, S.next_id(snapshot, :objects))
  end

  def we_have_enough_objectives?(_ev, snapshot) do
    snapshot
    |> S.contracts
    |> Contract.Collection.all_objectives_set_up?(snapshot |> S.objects)
  end

  # *** *******************************
  # *** CALLBACKS

  @impl Event
  def action(ev, snapshot) do
    snapshot
    |> S.put_new(objective(ev, snapshot))
  end

  @impl Event
  def post_guard(ev, snapshot) do
    if we_have_enough_objectives?(ev, snapshot) do
      :ok
    else
      {:error, "There are still objectives that need to be set up"}
    end
  end

end
