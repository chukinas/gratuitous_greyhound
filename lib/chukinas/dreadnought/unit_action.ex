alias Chukinas.Dreadnought.{UnitAction}

defmodule UnitAction do
  @moduledoc """
  Represents one action a unit will take next turn
  """

  # *** *******************************
  # *** TYPES

  @mode [:maneuver, :combat]
  @type unit_id() :: integer()
  @type mode() :: :maneuver | :combat

  use Chukinas.PositionOrientationSize

  typedstruct do
    field :unit_id, unit_id(), enforce: true
    field :mode, mode()
    # TODO rename target?
    # TODO replace :exit_or_run_aground with :noop
    field :value, :exit_or_run_aground | POS.position_type | :noop | unit_id
  end

  # *** *******************************
  # *** CONSTRUCTORS

  defp new(unit_id, mode, value) when is_integer(unit_id) and mode in @mode do
    %__MODULE__{
      unit_id: unit_id,
      mode: mode,
      value: value
    }
  end

  def move_to(unit_id, position) when has_position(position) do
    new(unit_id, :maneuver, position(position))
  end
  def exit_or_run_aground(unit_id) do
    new(unit_id, :maneuver, :exit_or_run_aground)
  end
  def fire_upon(unit_id, target_unit_id) when is_integer(target_unit_id) do
    new(unit_id, :combat, target_unit_id)
  end
  def combat_noop(unit_id), do: new(unit_id, :combat, :noop)

  # *** *******************************
  # *** CONVERTERS

  def is_maneuver?(action), do: action.mode == :maneuver
  def combat?(action), do: action.mode == :combat
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


# TODO move to separate module?
defmodule UnitAction.Enum do
  def maneuevers(actions) do
    # TODO rename maneuver?
    Stream.filter actions, &UnitAction.is_maneuver?/1
  end
  def combats(actions) do
    Stream.filter actions, &UnitAction.combat?/1
  end
end
