defmodule ChukinasWeb.AboutController do
  use ChukinasWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
