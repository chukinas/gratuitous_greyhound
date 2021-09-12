defmodule CollisionDetectionTest do
  use ExUnit.Case
  alias CollisionDetection.Entity
  import CollisionDetection.TestHelpers

  # *** *******************************
  # *** POLYGON

  test "Convex Polygon" do
    collides = fn polygon ->
      Entity.collides_with?(main_subject(), polygon)
    end
    assert collides.(inset_target())
    assert collides.(partially_overlapping_target())
    refute collides.(nonoverlapping_target())
  end

  test "Non-Convex Polygon" do
    collides = fn polygon ->
      Entity.collides_with?(reversed_main_subject(), polygon)
    end
    assert collides.(main_subject())
    assert collides.(inset_target())
    assert collides.(partially_overlapping_target())
    refute collides.(nonoverlapping_target())
  end

  # *** *******************************
  # *** LINE

  test "Lines and polygons" do
    collides = fn line ->
      Entity.collides_with?(reversed_main_subject(), line)
    end
    assert collides.(line(:yyy))
    assert collides.(line(:nyn))
    assert collides.(line(:nyy))
    assert collides.(line(:yyn))
    refute collides.(line(:nnn))
    refute collides.(line(:nnn_rev))
    assert collides.(line(:edge_to_edge))
    assert collides.(line(:edge_to_edge_rev))
  end

  # *** *******************************
  # *** POINT

  test "Points and polygons" do
    collides = fn point ->
      Entity.collides_with?(reversed_main_subject(), point)
    end
    assert collides.(point(:inside))
    refute collides.(point(:outside))
  end

end
