defmodule ChukinasWeb.JustOneController do
  use ChukinasWeb, :controller
  alias Phoenix.HTML.Link

  def index(conn, _params) do
    render(conn, "index.html")
  end


end
