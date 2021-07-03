defmodule ChukinasWeb.GalleryComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.Animation
  alias Chukinas.Dreadnought.Sprites


  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    sprites =
      Sprites.all()
      |> Enum.map(& Sprites.scale(&1, 2))
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
      struct: Animation.repeat(animation),
      rect: Animation.bounding_rect(animation)
    }
  end

end
