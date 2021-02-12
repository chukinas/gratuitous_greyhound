defprotocol Chukinas.Geometry.Position do

  @type position_tuple() :: {number(), number()}

  @spec to_tuple(t()) :: position_tuple()
  def to_tuple(position)

end

# TODO is there a cleaner way to write these long module names?
defimpl Chukinas.Geometry.Position, for: [Chukinas.Geometry.Pose, Chukinas.Geometry.Point] do

  def to_tuple(%{x: x, y: y}), do: {x, y}

end
