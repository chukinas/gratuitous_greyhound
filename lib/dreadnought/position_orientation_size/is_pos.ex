alias Dreadnought.PositionOrientationSize.{IsPos, Position, Size, Pose}

defprotocol IsPos do
  def keys(term)
end

defimpl IsPos, for: Position do
  def keys(_), do: ~w(x y)a
end

defimpl IsPos, for: Pose do
  def keys(_), do: ~w(x y angle)a
end

defimpl IsPos, for: Size do
  def keys(_), do: ~w(width height)a
end
