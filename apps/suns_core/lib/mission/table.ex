defmodule SunsCore.Mission.Table do

  alias __MODULE__
  alias SunsCore.Mission.HasTablePosition
  alias SunsCore.Space.TablePosition
  alias SunsCore.Space.ShapeWithArea

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: true do
    field :id, pos_integer
    field :shape, ShapeWithArea.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(pos_integer, ShapeWithArea.t) :: t
  def new(id, shape) do
    %__MODULE__{
      id: id,
      shape: shape
    }
  end

  # *** *******************************
  # *** CONVERTERS

  def id(%__MODULE__{id: value}), do: value
  def shape(%__MODULE__{shape: value}), do: value

  @spec assigned_to_table?(t, HasTablePosition.t) :: boolean
  def assigned_to_table?(table, item) do
    table_id = id(table)
    item_table_id =
      item
      |> HasTablePosition.table_position
      |> TablePosition.table_id
    table_id == item_table_id
  end

  # Does NOT check table IDs
  # Partial contains return true as well
  def contains_point_entity(table, item) do
    CollisionDetection.collide?(table, item)
  end

  def valid_table_position?(table, item) do
    assigned_to_table?(table, item) && contains_point_entity(table, item)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl CollisionDetection.Collidable do
    def entity(table) do
      table
      |> Table.shape
      |> ShapeWithArea.to_collision_detection_polygon
    end
  end

end
