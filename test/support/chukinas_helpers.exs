alias Chukinas.Dreadnought.{Mission, Unit}
alias Chukinas.Geometry.{Path, Pose, Position, Rect, Straight}

defmodule Chukinas.TestHelpers do

  use Chukinas.PositionOrientationSize

  defmacro __using__(_options) do
    quote do
      require Chukinas.TestHelpers
      import Chukinas.TestHelpers
    end
  end

  require ExUnit.Assertions
  import ExUnit.Assertions

  # *** *******************************
  # *** API

  @precision 0.1

  def compare_nums(a, b) do
    assert a == b
  end

  def assert_tuple_approx_equal(a, b) when tuple_size(a) == tuple_size(b) do
    [a, b] = for tuple <- [a, b] do
      list = for elem <- Tuple.to_list(tuple), do: Float.round(1.0 * elem, 1)
      List.to_tuple(list)
    end
    assert a == b
  end

  def assert_position_approx_equal(a, b) when has_position(a) == has_position(b) do
    [a, b] = for position <- [a, b], do: position_set_precision(position, 1)
    assert a == b
  end

  def assert_pose_approx_equal(a, b)
  when has_pose(a) == has_pose(b) do
    [a, b] = for pose <- [a, b], do: pose_set_precision(pose, 1)
    assert a == b
  end

end
