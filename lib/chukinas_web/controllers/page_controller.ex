defmodule ChukinasWeb.PageController do
  use ChukinasWeb, :controller
  alias Chukinas.Dreadnought.Unit.Builder

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
    conn = assign(conn,
      :units, [Builder.red_cruiser(1, 1)]
    )
    render conn, "homepage.html"
  end

end
