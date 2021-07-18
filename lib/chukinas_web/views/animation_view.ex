defmodule ChukinasWeb.AnimationView do

  use ChukinasWeb, :view

  def animations(socket, animations) when is_list(animations) do
    IOP.inspect animations, "animations"
    render "animations.html", socket: socket, animations: animations
  end

end
