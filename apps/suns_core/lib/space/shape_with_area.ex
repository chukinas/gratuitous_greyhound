defprotocol SunsCore.Space.ShapeWithArea do
  def to_collision_detection_polygon(shape)
end

use Spatial, :rect
defimpl SunsCore.Space.ShapeWithArea, for: Rect do
  def to_collision_detection_polygon(rect) do
    CollisionDetection.Collidable.entity(rect)
  end
end
