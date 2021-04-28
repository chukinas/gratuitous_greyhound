# TODO rename Arena?

defmodule ChukinasWeb.Dreadnought.StaticWorldComponent do
  use ChukinasWeb, :live_component

  # Note: this live component is actually necessary, because I never want its state to getupdated

  def render(assigns), do: ChukinasWeb.DreadnoughtView.render("component_static_world.html", assigns)

  def mount(socket), do: {:ok, socket}

end
