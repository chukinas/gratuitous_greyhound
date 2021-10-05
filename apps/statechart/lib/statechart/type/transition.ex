defmodule Statechart.Type.Transition do

  alias Statechart.Type.Event
  alias Statechart.Type.NodeName

  # *** *******************************
  # *** TYPES

  @type t :: {NodeName.t, Event.t, HState.t}

  # *** *******************************
  # *** CONSTRUCTORS

  def new(current_state, event, next_state) do
    {current_state, event, next_state}
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  @spec get_next_state(t, NodeName.t, Event.t) :: HState.t | nil
  def get_next_state(transition, current_state, %{__struct__: module}) do
    get_next_state(transition, current_state, module)
  end

  def get_next_state(transition, current_state, event) when is_atom(event) do
    case transition do
      {^current_state, ^event, next_state} -> next_state
      _ -> nil
    end
  end

end
