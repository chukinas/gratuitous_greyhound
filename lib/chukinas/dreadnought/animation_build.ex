alias Chukinas.Dreadnought.{Spritesheet, Animation}
alias Chukinas.Geometry.Pose

defmodule Animation.Build do

  # *** *******************************
  # *** NEW

  def simple_muzzle_flash(%Pose{} = pose, delay \\ 0) when is_number(delay) do
    frame =
      "explosion_" <> Enum.random(~w(1 2 3))
      |> Spritesheet.blue
      |> Animation.Frame.new(0)
    "simple muzzle flash"
    # TODO add fade
    |> Animation.new(pose, delay)
    |> Animation.put(frame)
    |> Animation.fade(0.5)
  end

  def large_muzzle_flash(%Pose{} = pose, delay \\ 0) when is_number(delay) do
    "large muzzle flash"
    |> Animation.new(pose, delay)
    |> Animation.put_frame(:blue, "muzzle_flash_A", 1)
    |> Animation.put_frame(:blue, "muzzle_flash_B", 1)
    |> Animation.put_frame(:blue, "muzzle_flash_C", 1)
    |> Animation.fade(0.5)
  end
end
