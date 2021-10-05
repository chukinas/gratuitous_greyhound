defmodule SunsCore.Mission.Contract do

  alias __MODULE__

  # *** *******************************
  # *** TYPES

  @type type :: :spades | :hearts | :clubs | :diamonds

  use TypedStruct
  typedstruct enforce: true do
    field :type, type
    field :name, String.t
    field :add_table?, boolean
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(name, add_table?) do
    %__MODULE__{
      type: :spades,
      name: name,
      add_table?: add_table?
    }
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  def add_table?(%__MODULE__{add_table?: value}), do: value

  # *** *******************************
  # *** IMPLEMENTATIONS

  # *** *******************************
  # *** COLLECTION

  defmodule Collection do
    @type t :: [Contract.t]
    def required_table_count(contracts) do
      1 + Enum.count(contracts, &Contract.add_table?/1)
    end
    def all_objectives_set_up?(_contracts, objectives) do
      # TODO temp
      Enum.count(objectives) >= 2
    end
  end

end
