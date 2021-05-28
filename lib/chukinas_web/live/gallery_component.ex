alias Chukinas.Dreadnought.{Spritesheet, Sprite, Animation}

defmodule ChukinasWeb.GalleryComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    sprites =
      Spritesheet.all()
      |> Enum.map(& Sprite.scale(&1, 2))
    animations = [
      Animation.Build.simple_muzzle_flash(pose_origin()),
      Animation.Build.large_muzzle_flash(pose_origin())
    ]
    |> Enum.map(&map_animation/1)
    socket =
      socket
      |> assign(sprites: sprites, animations: animations)
    {:ok, socket}
  end

  def map_animation(animation) do
    %{
      struct: Animation.repeat(animation) |> IO.inspect(structs: false),
      rect: Animation.bounding_rect(animation) |> IO.inspect(structs: false)
    }
    |> IOP.inspect
  end

end
