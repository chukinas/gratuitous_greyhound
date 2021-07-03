defmodule ChukinasWeb.DreadnoughtPlayView do
  use ChukinasWeb, :view

  def animations(socket, animations) do
    render("animations.html", socket: socket, animations: animations)
  end

end
