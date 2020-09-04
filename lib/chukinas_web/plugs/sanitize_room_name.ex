defmodule ChukinasWeb.Plugs.SanitizeRoomName do
  alias Phoenix.Controller
  alias Plug.Conn

  def init(opts) do
    opts
  end

  def call(%{:path_params => %{"room_name" => room_name}} = conn, _opts) do
    room_slug = slugify(room_name)
    if room_slug != room_name do
      path =
        conn.request_path
        |> URI.decode()
        |> String.replace(room_name, room_slug)
      conn
      |> Controller.redirect(to: path)
      |> Conn.halt()
    else
      conn
    end
  end

  def call(conn, _opts) do
    conn
  end

  def slugify(string) do
    string
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
