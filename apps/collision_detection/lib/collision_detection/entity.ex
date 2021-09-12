defmodule CollisionDetection.Entity do

  use TypedStruct
  use Spatial.LinearAlgebra
  alias Spatial.Vector
  alias CollisionDetection.Wrapper.Polygon, as: PolygonWrapper
  alias Collision.Detection.SeparatingAxis

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    field :coords, [Vector.t]
    field :type, atom
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(coords, :polygon  = type) when length(coords) >= 3, do: _new(coords, type)
 #def new(coords, :polyline = type) when length(coords) >= 2, do: _new(coords, type)
  def new(coords, :line     = type) when length(coords) == 2, do: _new(coords, type)
  def new(coords, :point    = type) when length(coords) == 1, do: _new(coords, type)

  defp _new(coords, type) do
    true = Enum.all?(coords, &is_vector/1)
    %__MODULE__{
      coords: coords,
      type: type
    }
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  defp coords(%__MODULE__{coords: value}), do: value

  defp to_wrapped_polygon(%__MODULE__{type: :point, coords: [coord_1]}) do
    # TODO I hate this hack, but good enough for now
    coord_2 = vector_add_x(coord_1, 0.0001)
    PolygonWrapper.from_coords([coord_1, coord_2])
  end

  defp to_wrapped_polygon(%__MODULE__{} = entity) do
    entity
    |> coords
    |> PolygonWrapper.from_coords
  end

  def collides_with?(entity_1, entity_2) do
    SeparatingAxis.collision?(
      to_wrapped_polygon(entity_1),
      to_wrapped_polygon(entity_2)
    )
  end

end
