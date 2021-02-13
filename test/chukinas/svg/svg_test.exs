ExUnit.start()

defmodule Chukinas.SvgTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "svg path string from straight path" do
    assert "l 10 0" = Path.new_straight(0, 0, 0, 10) |> Svg.to_string()
  end

  test "view box string from straight path" do
    assert "-10 -10 21 21" = Path.new_straight(0, 0, 45, :math.sqrt(2))
      |> Svg.new_viewbox()
      |> to_string()
  end
end
