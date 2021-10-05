defmodule SunsCore.Mission.Facility do

  use TypedStruct
  use SunsCore.Mission.ObjectiveBuilder

  # *** *******************************
  # *** TYPES

  default_objective_struct()

  # *** *******************************
  # *** CONSTRUCTORS

  def new(table_position, contract_type) do
    %__MODULE__{
      contract_type: contract_type,
      table_position: table_position
    }
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

end
