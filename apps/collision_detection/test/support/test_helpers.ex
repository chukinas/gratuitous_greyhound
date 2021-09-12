defmodule CollisionDetection.TestHelpers do

  alias CollisionDetection

  # *** *******************************
  # *** POLYGON

  # This is the main polygon I experiment with
  def main_subject do
    _binary_to_polygon """
     0  0
    10  0
    10 10
     0 10
    """
  end

  # Save as above, but
  # 1) points are befined in opposite order, and
  # 2) slightly larger.
  # Not "convex", which means ... what?
  # It still seems to function the same as the normal polygon
  def reversed_main_subject do
    _binary_to_polygon """
    -1 11
    11 11
    11 -1
    -1 -1
    """
  end

  # Fits completely within the main subject.
  # Collides.
  def inset_target do
    _binary_to_polygon """
    2 2
    8 2
    8 8
    2 8
    """
  end

  # Collide
  def partially_overlapping_target do
    _binary_to_polygon """
     5  5
    15  5
    15 15
     5 15
    """
  end

  # Does not collide
  def nonoverlapping_target do
    _binary_to_polygon """
    -5 -5
    -15 -5
    -15 -15
    -5 -15
    """
  end

  def all_convex do
    [
      main_subject(),
      inset_target(),
      partially_overlapping_target(),
      nonoverlapping_target()
    ]
  end

  defp _binary_to_polygon(str) do
    _binary_to_entity(str, :polygon)
  end

  # *** *******************************
  # *** LINE

  def line(:yyy), do: _binary_to_line "2 2 8 8"
  def line(:nyn), do: _binary_to_line "-5 5 15 5"
  def line(:nyy), do: _binary_to_line "-5 5 5 5"
  def line(:yyn), do: _binary_to_line "5 5 15 5"
  def line(:nnn), do: _binary_to_line "-5 15 15 15"
  def line(:nnn_rev), do: _binary_to_line "15 15 15 -5"
  def line(:edge_to_edge), do: _binary_to_line "0 0 10 10"
  def line(:edge_to_edge_rev), do: _binary_to_line "10 10 0 0"

  defp _binary_to_line(str) do
    _binary_to_entity(str, :line)
  end

  # *** *******************************
  # *** POINT

  def point(:inside), do: _binary_to_point "5 5"
  def point(:outside), do: _binary_to_point "15 15"

  defp _binary_to_point(str) do
    _binary_to_entity(str, :point)
  end

  # *** *******************************
  # *** HELPERS

  defp _binary_to_entity(str, type) do
    str
    |> String.split
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
    |> CollisionDetection.new(type)
  end

end
