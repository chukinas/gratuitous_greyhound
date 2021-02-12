alias Chukinas.Geometry.{Position, Pose, Point}

defprotocol Position do

  @type position_tuple() :: {number(), number()}

  @spec to_tuple(t()) :: position_tuple()
  def to_tuple(position)

end

defimpl Position, for: [Pose, Point] do

  def to_tuple(%{x: x, y: y}), do: {x, y}

end
