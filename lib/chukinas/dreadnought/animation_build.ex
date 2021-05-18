alias Chukinas.Dreadnought.{Spritesheet, Animation}
alias Chukinas.Geometry.Pose

defmodule Animation.Build do

  # *** *******************************
  # *** NEW

  def simple_muzzle_flash(%Pose{} = pose, delay \\ 0) when is_number(delay) do
    "simple muzzle flash"
    |> Animation.new(pose, delay)
    |> Animation.put(rand_explosion_frame(0))
    |> Animation.fade(0.5)
  end

  def large_muzzle_flash(%Pose{} = pose, delay \\ 0) when is_number(delay) do
    "large muzzle flash"
    |> Animation.new(pose, delay)
    |> Animation.put(rand_explosion_frame(0.05))
    #|> Animation.put_frame(:blue, "muzzle_flash_A", 0.1)
    |> Animation.put_frame(:blue, "muzzle_flash_A", 0.1)
    |> Animation.put_frame(:blue, "muzzle_flash_B", 0.1)
    |> Animation.put_frame(:blue, "muzzle_flash_C", 0.05)
    |> Animation.fade(0.5)
  end

  # *** *******************************
  # *** FUNCTIONS

  defp rand_explosion_frame(duration) do
    "explosion_" <> Enum.random(~w(1 2 3))
    |> Spritesheet.blue
    |> Animation.Frame.new(duration)
  end
end
