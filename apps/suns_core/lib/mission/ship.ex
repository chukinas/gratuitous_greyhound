defmodule SunsCore.Mission.Ship do

  alias SunsCore.Mission.HasTablePosition
  alias SunsCore.Mission.Ship
  alias SunsCore.Space.TablePose

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: true do
    field :id, pos_integer
    field :battlegroup_id, pos_integer
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
  # *** CONVERTERS

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** LIST TRANSFORMATIONS

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl HasTablePosition do
    def table_position(%Ship{table_pose: value}), do: value
  end

end
