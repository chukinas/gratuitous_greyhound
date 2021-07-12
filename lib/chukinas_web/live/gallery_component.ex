defmodule ChukinasWeb.GalleryComponent do

  use ChukinasWeb, :live_component
  use ChukinasWeb.Components
  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.Animations
  alias Chukinas.Dreadnought.Sprites


  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    sprites =
      Sprites.all()
      |> Enum.map(& Sprites.scale(&1, 2))
    animations = [
      Animations.simple_muzzle_flash(pose_origin()),
      Animations.large_muzzle_flash(pose_origin())
    ]
    |> Enum.map(&map_animation/1)
    socket =
      socket
      |> assign(sprites: sprites, animations: animations)
    {:ok, socket}
  end

  def map_animation(animation) do
    %{
      struct: Animations.repeat(animation),
      rect: Animations.bounding_rect(animation)
    }
  end

end
