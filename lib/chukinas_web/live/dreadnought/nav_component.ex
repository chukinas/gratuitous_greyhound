defmodule ChukinasWeb.DreadnoughtLive.NavComponent do

  use ChukinasWeb, :live_component

  # *** *******************************
  # *** CALLBACKS

  @impl true
  def mount(socket) do
    menu_items = for title <- ["Home", "Setup", "Gallery"], do: ChukinasWeb.MenuItem.new(title)
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
  end

  # *** *******************************
  # *** NEW

  def new(title) do
    %__MODULE__{title: title}
  end

end
