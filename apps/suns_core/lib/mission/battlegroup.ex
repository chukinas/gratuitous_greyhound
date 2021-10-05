defmodule SunsCore.Mission.Battlegroup do

  alias SunsCore.Mission.Battlegroup.Class

  use TypedStruct
  typedstruct enforce: true do
    field :id, pos_integer, default: :set_later
    field :player_id, pos_integer
    field :class_name, :atom
    field :starting_count, pos_integer
    field :deployed?, boolean, default: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(player_id, class_name, count) do
    %__MODULE__{
      player_id: player_id,
      class_name: class_name,
      starting_count: count
    }
  end

  # *** *******************************
  # *** REDUCERS

  def set_id(battlegroup, id) do
    %__MODULE__{battlegroup | id: id}
  end

  # *** *******************************
  # *** CONVERTERS

  def id(%__MODULE__{id: value}), do: value
  def class_name(%__MODULE__{class_name: value}), do: value

  def cost(%__MODULE__{class_name: class_name, starting_count: starting_count}) do
    class_name
    |> Class.cost
    |> Kernel.*(starting_count)
  end

  def starting_count(%__MODULE__{starting_count: value}), do: value

  # *** *******************************
  # *** LIST CONVERTERS

  @spec from_list_undeployed([t]) :: t
  def from_list_undeployed(battlegroups) when is_list(battlegroups) do
    [only_undeployed_battlegroup] =
      battlegroups
      |> Enum.reject(fn %__MODULE__{deployed?: deployed?} -> deployed? end)
    only_undeployed_battlegroup
  end

end
