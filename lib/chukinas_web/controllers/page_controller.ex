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
    render conn, "test_homepage.html"
  end

  def redirect_to_dreadnought(conn, _params) do
    redirect(conn, to: Routes.dreadnought_index_path(conn, :home))
  end

end
