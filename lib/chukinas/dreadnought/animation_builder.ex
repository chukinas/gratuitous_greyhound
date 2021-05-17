alias Chukinas.Dreadnought.{Spritesheet, Animation}
alias Chukinas.Geometry.Pose

defmodule Animation.Builder do

  # *** *******************************
  # *** NEW

  def simple_muzzle_flash(%Pose{} = pose, start) when is_number(start) do
    frame =
      "explosion_" <> Enum.random(~w(1 2 3))
      |> Spritesheet.blue
      |>  Animation.Frame.new(fade_duration: 1)
    Animation.new(pose, start)
    |> Animation.put(frame)
  end
end
