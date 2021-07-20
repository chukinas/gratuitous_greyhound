defmodule ChukinasWeb.AnimationView do

  use ChukinasWeb, :view
  alias Chukinas.Dreadnought.Animations

  def muzzle_flashes(socket, animations) do
    render_all(socket, animations |> Animations.list_muzzle_flashes |> IOP.inspect("view ani"))
  end

  def render_all(socket, animations) when is_list(animations) do
    render "animations.html", socket: socket, animations: animations
  end

  def single(socket, animation) do
    render "animation.html", socket: socket, animation: animation
  end

end
