alias Chukinas.Dreadnought.{Spritesheet, Animation}
alias Chukinas.Geometry.Pose

defmodule Animation.Build do

  # *** *******************************
  # *** NEW

  def simple_muzzle_flash(%Pose{} = pose, start \\ 0) when is_number(start) do
    frame =
      "explosion_" <> Enum.random(~w(1 2 3))
      |> Spritesheet.blue
      |> Animation.Frame.new(fade_duration: 0.5)
    "simple muzzle flash"
    |> Animation.new(pose, start)
    |> Animation.put(frame)
  end

  def large_muzzle_flash(%Pose{} = pose, start \\ 0) when is_number(start) do
    frame =
      "explosion_" <> Enum.random(~w(1 2 3))
      |> Spritesheet.blue
      |> Animation.Frame.new(fade_duration: 0.2)
    "large muzzle flash"
    |> Animation.new(pose, start)
    |> Animation.put(frame)
    |> Animation.put_frame(:blue, "muzzle_flash_A", 0.2, 0.2)
    |> Animation.put_frame(:blue, "muzzle_flash_B", 0.4, 0.2)
    |> Animation.put_frame(:blue, "muzzle_flash_C", 0.6, 0.2)
  end
end
