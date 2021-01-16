defmodule Chukinas.Dreadnought.Cartesian do

  @type coordinate :: {integer(), integer()}

  @spec translate_coordinate_list([coordinate], coordinate) :: [coordinate]
  def translate_coordinate_list(coords, translation) do
    coords
    |> Enum.map(&translate_coordinate(&1, translation))
    # TODO I don't like the term translation
  end 

  @spec translate_coordinate(coordinate, coordinate) :: coordinate
  def translate_coordinate({x, y}, {dx, dy}) do
    {x + dx, y + dy}        
  end 

  # TODO angle is ok being integer. coord tho, that needs to be float
  @spec rotate_coordinate_list(coordinate, integer) :: coordinate
  def rotate_coordinate_list(coords, angle_deg) do
    coords
    |> Enum.map(&rotate_coordinate(&1, angle_deg))
  end 

  @spec rotate_coordinate(coordinate, integer) :: coordinate
  def rotate_coordinate({x, y}, angle_deg) do
    angle_rad = deg_to_rad(angle_deg)
    x1 = x * :math.cos(angle_rad) - y * :math.sin(angle_rad)
    y1 = y * :math.cos(angle_rad) + x * :math.sin(angle_rad)
    {x1, y1}
  end 

  def deg_to_rad(angle_deg) do
    angle_deg * :math.pi() / 180
  end

  def mirror_x({x, y}) do
    {x, -y}
  end

  def mirror_y({x, y}) do
    {-x, y}
  end
end
