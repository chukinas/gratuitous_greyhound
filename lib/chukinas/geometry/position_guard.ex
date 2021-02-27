# TODO rename PositionGuard
# TODO make note here that Position.is should be used instead.
defmodule Chukinas.Geometry.Position.Guard do

  defguard has_position(position)
    when is_map_key(position, :x)
    and is_map_key(position, :y)

end
