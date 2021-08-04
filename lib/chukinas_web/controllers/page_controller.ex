defmodule ChukinasWeb.PageController do
  use ChukinasWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def minis(conn, _params) do
    render conn, "minis.html"
  end

  def music(conn, _params) do
    render conn, "music.html"
  end

  def dev(conn, _params) do
    menu_items = for title <- ["Home", "Setup", "Gallery"], do: ChukinasWeb.MenuItem.new(title)
    render conn, "menu2.html", menu_items: menu_items
  end

  def redirect_to_dreadnought(conn, _params) do
    redirect(conn, to: Routes.dreadnought_homepage_path(conn, :homepage))
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
