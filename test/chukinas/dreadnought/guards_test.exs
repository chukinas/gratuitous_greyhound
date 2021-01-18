ExUnit.start()

defmodule Chukinas.Dreadnought.GuardsTest do
  import Chukinas.Dreadnought.Guards
  use ExUnit.Case, async: true

  test "is_point checks tuple, length and is_number of elements" do
    assert is_point({1, 2})
    refute is_point({"1", "2"})
    refute is_point({1})
    refute is_point(1)
  end

end
