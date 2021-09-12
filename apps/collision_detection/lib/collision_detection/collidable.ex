defprotocol CollisionDetection.Collidable do
  @moduledoc """
  Any 2D polygon (3+ sides/vertices) may implement this protocol for easy convertion to `CollisionDetection.Polygon`
  """

  @spec entity(any) :: CollisionDetection.Entity.t
  def entity(element)

end

defimpl CollisionDetection.Collidable, for: Tuple do
  def entity(vector) do
    CollisionDetection.point(vector)
  end
end

defimpl CollisionDetection.Collidable, for: Rect do
  def entity(rect) do
    rect
    |> Spatial.Geometry.Rect.to_coords
    |> CollisionDetection.polygon
  end
end

defmodule CollisionDetection.CollidableImpl do

  defmacro __using__(:map_to_point) do
    quote do
      defimpl CollisionDetection.Collidable do
        def entity(%{x: x, y: y}) do
          CollisionDetection.Collidable.entity {x, y}
        end
      end
    end
  end

end
