defmodule SunsCore.Mission.Battlegroup do

  alias SunsCore.Mission.Battlegroup.Class
  alias SunsCore.Mission.Ship

  use Util.GetterStruct
  getter_struct do
    field :id, pos_integer, default: :set_later
    field :player_id, pos_integer
    field :class_name, :atom
    field :starting_count, pos_integer
    field :deployed?, boolean, default: false
    # TODO need to un-activate this at end of tactical phase
    field :activated?, boolean, default: false
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

  # TODO this doesn't really belong here...
  def new_bg_and_ships(class_symbol, table_poses, helm_id, bg_id, ship_starting_id) do
    bg =
      struct!(__MODULE__, %{
        id: bg_id,
        player_id: helm_id,
        class_name: class_symbol,
        starting_count: Enum.count(table_poses),
        deployed?: true
      })
    ships =
      ship_starting_id
      |> Stream.iterate(&(&1 + 1))
      |> Stream.zip(table_poses)
      |> Enum.map(fn {id, table_pose} ->
        Ship.new(id, bg_id, class_symbol, table_pose)
      end)
    {bg, ships}
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

  # TODO these should replace the old names
  def class_symbol(%__MODULE__{} = bg) do
    class_name(bg)
  end

  def controller(%__MODULE__{} = bg) do
    player_id(bg)
  end

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
