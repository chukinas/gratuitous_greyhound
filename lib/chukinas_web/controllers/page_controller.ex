defmodule ChukinasWeb.PageController do
  use ChukinasWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/dreadnought")
  end
end
