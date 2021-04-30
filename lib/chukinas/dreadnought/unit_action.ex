alias Chukinas.Dreadnought.{UnitAction}
alias Chukinas.Geometry.{Position}

defmodule UnitAction do
  @moduledoc """
  Represents one action a unit will take at the end of the turn
  """

  # *** *******************************
  # *** TYPES

  @type unit_id() :: integer()

  use TypedStruct
  typedstruct do
    field :unit_id, unit_id(), enforce: true
    field :type, :maneuver | :combat
    field :value, :exit_or_run_aground | Position.t()
  end

  # *** *******************************
  # *** NEW

  defp new(unit_id, type, value) do
    %__MODULE__{
      unit_id: unit_id,
      type: type,
      value: value
    }
  end

  def move_to(unit_id, %Position{} = position) do
    new(unit_id, :maneuver, position)
  end
  def exit_or_run_aground(unit_id) do
    new(unit_id, :maneuver, :exit_or_run_aground)
  end

  # *** *******************************
  # *** GETTERS

  def is_maneuver?(action), do: action.type == :maneuver
  def value(action), do: action.value

end


# TODO rename .Coll or .Enum
defmodule UnitAction.List do
  def maneuevers(actions) do
    Stream.filter actions, &UnitAction.is_maneuver?/1
  end
end
