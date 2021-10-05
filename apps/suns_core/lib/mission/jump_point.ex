defmodule SunsCore.Mission.JumpPoint do

  alias __MODULE__
  alias SunsCore.Mission.HasTablePosition
  alias SunsCore.Space.TablePosition

  # *** *******************************
  # *** TYPES

  @type turn_number :: pos_integer

  use TypedStruct
  typedstruct enforce: true do
    field :id, pos_integer
    field :player_id, pos_integer
    field :table_position, TablePosition.t
    field :last_updated, turn_number
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(player_id, id, %TablePosition{} = table_position, turn_number) do
    %__MODULE__{
      id: id,
      player_id: player_id,
      table_position: table_position,
      last_updated: turn_number
    }
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  #def table_position(%__MODULE__{table_position: value}), do: value

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl HasTablePosition do
    def table_position(%JumpPoint{table_position: value}), do: value
  end

  defimpl CollisionDetection.Collidable do
    def entity(jump_point) do
      jump_point
      |> HasTablePosition.table_position
      |> CollisionDetection.Collidable.entity
    end
  end

end
