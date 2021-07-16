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
    IO.puts Routes.static_url(conn, "/images/crinkled_paper_20210517.jpg")
    IO.puts Routes.static_path(conn, "/images/crinkled_paper_20210517.jpg")
    render assign(conn, :hello, "Hello, I love you"), "dev.html"
  end

end
