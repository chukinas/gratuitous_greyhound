defmodule ChukinasWeb.DreadnoughtLive.NavComponent do

  use ChukinasWeb, :live_component

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    menu_items =
      [
        ChukinasWeb.MenuItem.new("Home", Routes.dreadnought_main_path(socket, :homepage)),
        ChukinasWeb.MenuItem.new("Join a Game", Routes.dreadnought_path(socket, :setup)),
        ChukinasWeb.MenuItem.new("Gallery", Routes.dreadnought_main_path(socket, :gallery)),
      ]
    socket =
      assign(socket, menu_items: menu_items)
    {:ok, socket}
  end

end

defmodule ChukinasWeb.MenuItem do

  use TypedStruct

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    field :title, String.t
    field :route, String.t
  end

  # *** *******************************
  # *** NEW

  def new(title, route) do
    %__MODULE__{title: title, route: route}
  end

end
