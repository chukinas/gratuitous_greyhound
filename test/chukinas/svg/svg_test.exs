ExUnit.start()

defmodule Chukinas.SvgTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "svg path string from straight path" do
    assert "M 0 0 L 10 0" = Path.new_straight(0, 0, 0, 10) |> Svg.get_path_string()
  end
end
