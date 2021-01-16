defmodule Chukinas.Dreadnought.Cartesian do

  @type coordinate :: {number(), number()}

  @spec translate_coordinate_list([coordinate], coordinate) :: [coordinate]
  def translate_coordinate_list(coords, dxdy) do
    coords
    |> Enum.map(&translate_coordinate(&1, dxdy))
  end 

  @spec translate_coordinate(coordinate, coordinate) :: coordinate
  def translate_coordinate({x, y}, {dx, dy}) do
    {x + dx, y + dy}        
  end 

  @spec rotate_coordinate_list([coordinate], number()) :: [coordinate]
  def rotate_coordinate_list(coords, angle_deg) do
    coords
    |> Enum.map(&rotate_coordinate(&1, angle_deg))
  end 

  @spec rotate_coordinate(coordinate, number()) :: coordinate
  def rotate_coordinate({x, y}, angle_deg) do
    angle_rad = deg_to_rad(angle_deg)
    x1 = x * :math.cos(angle_rad) - y * :math.sin(angle_rad)
    y1 = y * :math.cos(angle_rad) + x * :math.sin(angle_rad)
    {x1, y1}
  end 

  @spec deg_to_rad(number()) :: number()
  def deg_to_rad(angle_deg) do
    angle_deg * :math.pi() / 180
  end

  @spec mirror_x(coordinate()) :: coordinate()
  def mirror_x({x, y}) do
    {x, -y}
  end

  @spec mirror_y(coordinate()) :: coordinate()
  def mirror_y({x, y}) do
    {-x, y}
  end
end
