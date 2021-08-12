alias Dreadnought.Core.{Unit}

defmodule Unit.Status do
  @moduledoc """
  Tracks unit damage, whether it's alive or dead, visible, etc
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: true do
    field :render?, boolean(), default: true
    field :active?, boolean(), default: true
  end

  # *** *******************************
  # *** NEW

  def new(render?, active?) do
    %__MODULE__{
      render?: render?,
      active?: active?
    }
  end

  def new() do
    %__MODULE__{}
  end

  # *** *******************************
  # *** SETTERS

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
