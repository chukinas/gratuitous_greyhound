alias Chukinas.Dreadnought.{Player, ActionSelection}

defmodule Player do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :type, :human | :ai
    field :action_selection, ActionSelection.t(), enforce: false, default: []
  end

  # *** *******************************
  # *** NEW

  def new(id, type) when type in ~w(human ai)a do
    %__MODULE__{
      id: id,
      type: type
    }
  end

  # *** *******************************
  # *** API

  def put(player, %ActionSelection{} = action_selection) do
    %{player | action_selection: action_selection}
  end

  def clear(player) do
    %{player | action_selection: nil}
  end
end
