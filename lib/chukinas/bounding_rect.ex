alias Chukinas.BoundingRect
alias Chukinas.Geometry.Rect

defprotocol BoundingRect do
  def of(item)
end

defimpl BoundingRect, for: [Chukinas.Dreadnought.Sprite] do
  def of(item), do: Rect.from_map(item)
end

defimpl BoundingRect, for: [Chukinas.Dreadnought.Unit] do
  def of(%{rect: rect}), do: Rect.from_map(rect)
end

defimpl BoundingRect, for: [
  Chukinas.PositionOrientationSize.Position,
  Chukinas.PositionOrientationSize.Pose
] do
  def of(%{x: x, y: y}), do: Rect.new(x, y, 0, 0)
end

defimpl BoundingRect, for: Rect do
  def of(rect), do: rect
end

defimpl BoundingRect, for: List do
  def of([head | tail]) do
    start_rect = BoundingRect.of(head)
    Enum.reduce(tail, start_rect, fn term, rect ->
      term
      |> BoundingRect.of
      |> Rect.bounding_rect(rect)
    end)
  end
end
