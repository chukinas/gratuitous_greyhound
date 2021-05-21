alias Chukinas.Dreadnought.{Unit}

defmodule Unit.Status do
  @moduledoc """
  Tracks unit damage, whether it's alive or dead, visible, etc
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: true do
    # TODO remove
    field :final_turn, integer(), enforce: false
    field :render?, boolean(), default: true
    field :active?, boolean(), default: true
  end

  # *** *******************************
  # *** NEW

  def new() do
    %__MODULE__{}
  end

  # *** *******************************
  # *** SETTERS

  def out_of_action(unit_status, turn_number) do
    %__MODULE__{unit_status | final_turn: turn_number}
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
  # *** GETTERS

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
