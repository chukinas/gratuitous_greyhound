alias Chukinas.Dreadnought.{Unit}
alias Chukinas.Util.{Maps}

defmodule Unit.Status do
  @moduledoc """
  Tracks unit damage, whether it's alive or dead, visible, etc
  """

  # *** *******************************
  # *** TYPES

  @type damage :: {turn_number :: integer(), damage_points :: integer()}

  use TypedStruct
  typedstruct enforce: true do
    # TODO rename max_damage_points
    field :health, damage()
    # TODO rename :turn_lost
    field :final_turn, integer(), enforce: false
    field :damage, [damage()], default: []
    field :render?, boolean(), default: true
    field :active?, boolean(), default: true
  end

  # *** *******************************
  # *** NEW

  def new(max_damage) do
    %__MODULE__{health: max_damage}
  end

  # *** *******************************
  # *** SETTERS

  def out_of_action(unit_status, turn_number) do
    %__MODULE__{unit_status | final_turn: turn_number}
  end

  def take_damage(unit_status, damage, turn_number) do
    Maps.push(unit_status, :damage, {turn_number, damage})
  end

  def calc_active(unit_status, turn_number) do
    %__MODULE__{unit_status | active?: case unit_status.final_turn do
      nil -> true
      turn when turn_number >= turn -> false
      _ -> true
    end}
  end

  def calc_render(unit_status, turn_number) do
    %__MODULE__{unit_status | render?: case unit_status.final_turn do
      nil -> true
      turn when turn_number > turn -> false
      _ -> true
    end}
  end

  # *** *******************************
  # *** CALC

  def maybe_succumb_to_damage(unit_status) do
    # TODO implement
    unit_status
  end

  # *** *******************************
  # *** GETTERS

  def total_damage(%{damage: damages}) do
    damages
    |> Stream.map(fn {_turn, damage} -> damage end)
    |> Enum.sum
  end
  def remaining_health(%{health: health} = unit) do
    (health - total_damage(unit))
    |> max(0)
  end
  def percent_remaining_health(%{health: health} = unit) do
    (1 - total_damage(unit) / health)
    |> max(0)
  end
  def active?(%__MODULE__{active?: active?}), do: active?

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(unit_status, opts) do
      col = fn string -> color(string, :cust_struct, opts) end
      unit_map =
        unit_status
        |> Map.take([
          :damage,
        ])
        |> Enum.into([])
      concat [
        col.("#UnitStatus<"),
        to_doc(unit_map, opts),
        col.(">")
      ]
    end
  end
end
