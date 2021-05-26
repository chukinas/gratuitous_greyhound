# TODO rename PositionGuard
# TODO make note here that Position.is should be used instead.
# TODO rename module
defmodule Chukinas.Geometry.Position.Guard do

  defguard has_position(position)
    when is_map_key(position, :x)
    and is_map_key(position, :y)

  defguard has_pose(pose)
    when has_position(pose)
    and is_map_key(pose, :angle)

end
