defmodule Chukinas.Dreadnought.Cartesian do

  @type coordinate :: {integer(), integer()}

  @spec translate_coordinate_list([coordinate], coordinate) :: [coordinate]
  def translate_coordinate_list(coords, translation) do
    coords
    |> Enum.map(translation)
  end 

  @spec translate_coordinate(coordinate, coordinate) :: coordinate
  def translate_coordinate({x, y}, {dx, dy}) do
    {x + dx, y + dy}        
  end 

  @spec rotate_coordinate_list(coordinate, integer) :: coordinate
  def rotate_coordinate_list({x, y}, angle_deg) do
    angle_rad = deg_to_rad(angle_deg)
    x1 = x * :math.cos(angle_rad) - y * :math.sin(angle_rad)
    y1 = y * :math.cos(angle_rad) + x * :math.sin(angle_rad)
    {x1, y1}
  end 

  def deg_to_rad(angle_deg) do
    angle_deg * :math.pi() / 180
  end

end
