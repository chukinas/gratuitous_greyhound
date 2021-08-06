defmodule ChukinasWeb.AnimationView do

  use ChukinasWeb, :view
  alias Chukinas.Dreadnought.Animations
  alias Chukinas.Dreadnought.Animation
  alias Chukinas.Dreadnought.Sprite

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
    ChukinasWeb.SpriteView.absolute_sprite(socket, sprite)
  end

end
