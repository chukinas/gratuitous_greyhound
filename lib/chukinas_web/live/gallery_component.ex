alias Chukinas.Dreadnought.{Spritesheet, Sprite, Animation}
alias Chukinas.Geometry.Pose

defmodule ChukinasWeb.GalleryComponent do
  use ChukinasWeb, :live_component
  use ChukinasWeb.Components

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    sprites =
      Spritesheet.all()
      |> Enum.map(& Sprite.scale(&1, 2))
    animations = [
      Animation.Build.simple_muzzle_flash(Pose.origin()),
      Animation.Build.large_muzzle_flash(Pose.origin())
    ]
    |> Enum.map(&map_animation/1)
    socket =
      socket
      |> assign(sprites: sprites, animations: animations)
    {:ok, socket}
  end

  def map_animation(animation) do
    %{
      struct: Animation.repeat(animation),
      rect: Animation.bounding_rect(animation)
    }
  end

end
