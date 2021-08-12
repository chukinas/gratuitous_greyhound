defmodule DreadnoughtWeb.AnimationView do

  use DreadnoughtWeb, :view
  alias Dreadnought.Core.Animations
  alias Dreadnought.Core.Animation
  alias Dreadnought.Core.Sprite

  def muzzle_flashes(socket, animations) do
    render_all(socket, animations |> Animations.list_muzzle_flashes)
  end

  def render_all(socket, animations) when is_list(animations) do
    render "animations.html", socket: socket, animations: animations
  end

  def single(socket, animation) do
    render "animation.html", socket: socket, animation: animation
  end

  def render_animation_or_sprite(socket, %Animation{} = animation) do
    single(socket, animation)
  end
  def render_animation_or_sprite(socket, %Sprite{} = sprite) do
    DreadnoughtWeb.SpriteView.absolute_sprite(socket, sprite)
  end

end
