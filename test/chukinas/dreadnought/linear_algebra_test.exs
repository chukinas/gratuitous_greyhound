ExUnit.start()


defmodule LinearAlgebraTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers
  alias Chukinas.LinearAlgebra.{CSys}
  alias CSys.Conversion

  test "get world origin wrt unit" do
    origin_wrt_unit =
      Pose.new(1, 1, 90)
      |> CSys.new
      |> CSys.flip
      |> CSys.position
    assert origin_wrt_unit == {-1, 1}
  end

  test "get world origin wrt mount" do
    unit_tranform_reversed =
      Pose.new(1, 1, 90)
      |> CSys.new
      |> CSys.flip
    mount_tranform_reversed =
      Pose.new(2, 0, 180)
      |> CSys.new
      |> CSys.flip
    origin_wrt_mount =
      mount_tranform_reversed
      |> CSys.transform(CSys.position(unit_tranform_reversed))
    assert origin_wrt_mount == {3, -1}
  end

  test "get world {10, 10} wrt mount" do
    world_point_of_interest = {10, 10}
    unit_tranform_reversed =
      Pose.new(1, 1, 90)
      |> CSys.new
      |> CSys.flip
    point_wrt_unit = CSys.transform(unit_tranform_reversed, world_point_of_interest)
    mount_tranform_reversed =
      Pose.new(2, 0, 180)
      |> CSys.new
      |> CSys.flip
    point_wrt_mount =
      mount_tranform_reversed
      |> CSys.transform(point_wrt_unit)
    assert point_wrt_mount == {-7, 9}
  end

  test "get world {10, 10} wrt mount using CSys.Conversion" do
    alias CSys.Conversion
    world_point_of_interest = {10, 10}
    unit_tranform = CSys.new(1, 1, 90)
    mount_tranform = CSys.new(2, 0, 180)
    point_wrt_mount =
      world_point_of_interest
      |> Conversion.new
      |> Conversion.put_inv(unit_tranform)
      |> Conversion.put_inv(mount_tranform)
      |> Conversion.get_vector
    assert point_wrt_mount == {-7, 9}
  end

  test "get angle b/w mount and target" do
    world_point_of_interest = {2, 4}
    unit_csys = CSys.new(1, 1, 90)
    mount_csys = CSys.new(2, 0, 0)
    turret_angle =
      world_point_of_interest
      |> Conversion.new
      |> Conversion.put_inv(unit_csys)
      |> Conversion.put_inv(mount_csys)
      |> Conversion.get_angle
      |> round
    assert turret_angle == (360 -45)
  end

  test "get csys angle" do
    angles = 0..11 |> Stream.map(& &1 * 30)
    Enum.each(angles, fn angle ->
      csys = CSys.new(0, 0, angle)
      assert round(CSys.angle(csys)) == angle
    end)
  end

  test "get world coord for gun barrel" do
    turret_barrel = {20, 0}
    turret_csys = CSys.new(20, 0, 90)
    unit_csys = CSys.new(20, 0, 90)
    expected_world_coord = {0, 20}
    actual_coord =
      turret_barrel
      |> Conversion.new
      |> Conversion.put(turret_csys)
      |> Conversion.put(unit_csys)
      |> Conversion.get_vector
    assert expected_world_coord == actual_coord
  end
end
