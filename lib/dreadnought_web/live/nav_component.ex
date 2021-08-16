defmodule DreadnoughtWeb.NavComponent do

  use DreadnoughtWeb, :live_component

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    build_menu_item =
      fn title, live_action ->
        route = Routes.dreadnought_main_path(socket, live_action)
        DreadnoughtWeb.MenuItem.new(title, route)
      end
    menu_items =
      [
        build_menu_item.("Home", :homepage),
        build_menu_item.("Join a Game", :setup),
        build_menu_item.("Gallery", :gallery)
      ]
    socket
    |> assign(menu_items: menu_items)
    |> ok
  end

end

defmodule DreadnoughtWeb.MenuItem do

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
    %__MODULE__{
      title: title,
      route: route
    }
  end

end
