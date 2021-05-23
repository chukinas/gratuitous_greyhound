defmodule ChukinasWeb.Plugs.AssignUrl do
  alias Phoenix.Controller
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    url = Controller.current_url(conn)
    conn
    |> assign(:url, url)
  end
end
