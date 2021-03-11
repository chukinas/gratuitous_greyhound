defmodule ChukinasWeb.ZoomPanController do
  use ChukinasWeb, :controller

  def index(conn, _params) do
    html(conn, """
      Hi!
    """)
  end
end
