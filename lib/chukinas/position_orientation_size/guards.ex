defmodule Chukinas.PositionOrientationSize.Guards do

  defguard has_position(position)
    when is_map_key(position, :x)
    and is_map_key(position, :y)

  defguard has_pose(pose)
    when has_position(pose)
    and is_map_key(pose, :angle)

  defguard has_size(size)
    when is_map_key(size, :width)
    and is_map_key(size, :height)

  defguard has_position_and_size(element)
    when has_position(element)
    and has_size(element)

end
