defmodule Dreadnought.Core.Animations do

  use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Animation
  alias Dreadnought.Core.AnimationFrame
  alias Dreadnought.Core.Sprites

  # *** *******************************
  # *** CONSTRUCTORS

  def simple_muzzle_flash(pose, delay \\ 0) when is_number(delay) do
    "simple muzzle flash"
    |> Animation.new(:muzzle_flash, pose, delay)
    |> Animation.put(rand_explosion_frame(0))
    |> Animation.fade(0.5)
  end

  def large_muzzle_flash(pose, delay \\ 0) when is_number(delay) do
    "large muzzle flash"
    |> Animation.new(:muzzle_flash, pose, delay)
    |> Animation.put(rand_explosion_frame(0.05))
    #|> Animation.put_frame(:blue, "muzzle_flash_A", 0.1)
    |> Animation.put_frame(:blue, "muzzle_flash_A", 0.1)
    |> Animation.put_frame(:blue, "muzzle_flash_B", 0.1)
    |> Animation.put_frame(:blue, "muzzle_flash_C", 0.05)
    |> Animation.fade(0.5)
  end

  def ordnance_hit(pose, delay \\ 0) when is_number(delay) do
    "ordnance_hit"
    |> Animation.new(:hit, pose, delay)
    |> Animation.put(rand_explosion_frame(0.05))
    |> Animation.put_frame(:red, "muzzle_flash", 0)
    |> Animation.fade(0.5)
  end

  # *** *******************************
  # *** REDUCERS

  defdelegate repeat(animation), to: Animation

  # *** *******************************
  # *** LIST REDUCERS

  def list_muzzle_flashes(animations) when is_list(animations) do
    Enum.filter animations, &Animation.muzzle_flash?/1
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  defp rand_explosion_frame(duration) do
    "explosion_" <> Enum.random(~w(1 2 3))
    |> Sprites.blue
    |> AnimationFrame.new(duration)
  end
end
