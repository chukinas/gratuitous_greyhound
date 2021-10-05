alias Spatial.Collide.Shape

defimpl Spatial.Collide.IsShape, for: Shape do
  def to_coords(polygon), do: Shape.coords(polygon)
end
