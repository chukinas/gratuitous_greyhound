alias Chukinas.Dreadnought.{Player, UnitOrders}

defmodule Player do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :type, :human | :ai
    # TODO there is no need for these. Flatten. Put in Mission
    field :commands, [UnitOrders.t()], default: []
    field :turn_complete?, boolean, default: false
  end

  # *** *******************************
  # *** NEW

  def new(id, type) when type in ~w(human ai)a do
    %__MODULE__{
      id: id,
      type: type
    }
  end

  def clear(%__MODULE__{id: id, type: type}), do: new(id, type)

  # *** *******************************
  # *** GETTERS

  def id(%__MODULE__{id: id}), do: id
  def commands(%__MODULE__{commands: commands}), do: commands
  def turn_complete?(%__MODULE__{turn_complete?: turn_complete?}), do: turn_complete?
  def ai?(%__MODULE__{type: type}), do: type === :ai

  # *** *******************************
  # *** SETTERS

  def put_commands(%__MODULE__{} = player, commands) when is_list(commands) do
    %{player |
      commands: commands,
      turn_complete?: true
    }
  end
end
