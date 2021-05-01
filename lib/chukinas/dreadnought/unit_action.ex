alias Chukinas.Dreadnought.{UnitAction}
alias Chukinas.Geometry.{Position}

defmodule UnitAction do
  @moduledoc """
  Represents one action a unit will take next turn
  """

  # *** *******************************
  # *** TYPES

  @mode [:maneuver, :combat]
  @type unit_id() :: integer()
  @type mode() :: :maneuver | :combat

  use TypedStruct
  typedstruct do
    field :unit_id, unit_id(), enforce: true
    field :mode, mode()
    # TODO rename target?
    field :value, :exit_or_run_aground | Position.t()
  end

  # *** *******************************
  # *** NEW

  defp new(unit_id, mode, value) when is_integer(unit_id) and mode in @mode do
    %__MODULE__{
      unit_id: unit_id,
      mode: mode,
      value: value
    }
  end

  def move_to(unit_id, %Position{} = position) do
    new(unit_id, :maneuver, position)
  end
  def exit_or_run_aground(unit_id) do
    new(unit_id, :maneuver, :exit_or_run_aground)
  end
  def fire_upon(unit_id, target_unit_id) when is_integer(target_unit_id) do
    new(unit_id, :combat, target_unit_id)
  end

  # *** *******************************
  # *** GETTERS

  def is_maneuver?(action), do: action.mode == :maneuver
  def value(action), do: action.value
  def id_and_mode(%{unit_id: id, mode: mode}), do: {id, mode}

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(action, opts) do
      mode = action.mode |> Atom.to_string |> String.capitalize |> String.pad_trailing(8)
      values = [unit: action.unit_id, target: action.value]
      concat ["$#{mode}", to_doc(values, opts)]
    end
  end

end


defmodule UnitAction.Enum do
  def maneuevers(actions) do
    Stream.filter actions, &UnitAction.is_maneuver?/1
  end
end
