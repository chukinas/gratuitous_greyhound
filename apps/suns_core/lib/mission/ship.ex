defmodule SunsCore.Mission.Ship do

  alias SunsCore.Mission.Ship
  alias SunsCore.Space.TablePose

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :id, pos_integer
    field :battlegroup_id, pos_integer
    # TODO rename class_symbol
    field :class_name, atom
    field :table_pose, TablePose.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(id, battlegroup_id, class_name, %TablePose{} = table_pose) do
    %__MODULE__{
      id: id,
      battlegroup_id: battlegroup_id,
      class_name: class_name,
      table_pose: table_pose
    }
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  def belongs_to?(%__MODULE__{} = ship, battlegroup_id) do
    ship.battlegroup_id === battlegroup_id
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl SunsCore.Space.Poseable do

    defdelegate table_pose(ship), to: Ship

  end

end
