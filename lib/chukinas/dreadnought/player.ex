alias Chukinas.Dreadnought.{Player, UnitOrders}

defmodule Player do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :type, :human | :ai
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
  # *** GETTERS

  def id(%__MODULE__{id: id}), do: id
  def ai?(%__MODULE__{type: type}), do: type === :ai
end
