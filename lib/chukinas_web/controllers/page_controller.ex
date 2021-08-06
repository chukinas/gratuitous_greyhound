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
    render conn, "menu.html", menu_items: menu_items
  end

  def redirect_to_dreadnought(conn, _params) do
    redirect(conn, to: Routes.dreadnought_homepage_path(conn, :homepage))
  end

  def redirect_to_goodreads_elixir(conn, _params) do
    redirect(conn, external: "https://www.goodreads.com/review/list/131896976-jonathan-chukinas?shelf=full-stack-web-developer")
  end

end
