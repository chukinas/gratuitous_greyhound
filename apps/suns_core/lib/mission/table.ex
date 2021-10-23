defmodule SunsCore.Mission.Table do

  alias __MODULE__
  alias SunsCore.Space.Poseable
  alias SunsCore.Space.TablePose
  alias SunsCore.Space.ShapeWithArea
  alias Util.Response

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

  @spec assigned_to_table?(t, Poseable.t) :: boolean
  def assigned_to_table?(table, item) do
    table_id = id(table)
    item_table_id =
      item
      |> Poseable.table_pose
      |> TablePose.table_id
    table_id == item_table_id
  end

  # Does NOT check table IDs
  # Partial contains return true as well
  def contains_point_entity(table, item) do
    CollisionDetection.collide?(table, item)
  end

  @spec check_contains_points(any, any) :: Response.t
  def check_contains_points(_table, _items) do
    # TODO implement
    true
    |> Response.from_bool("Subject is outside the table's boundary")
  end

  def valid_table_pose?(table, item) do
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
