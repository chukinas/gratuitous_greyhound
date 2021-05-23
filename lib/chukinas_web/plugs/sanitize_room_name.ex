defmodule ChukinasWeb.Plugs.SanitizeRoomName do
  # TODO how to add documentation?
  alias Phoenix.Controller
  alias Plug.Conn

  def init(opts) do
    opts
  end

  def call(%{:path_params => %{"room" => room_name}} = conn, _opts) do
    IOP.inspect conn.path_info, "sanitize"
    IOP.inspect Phoenix.Controller.current_url(conn, %{name: "bill"}), "sanitize"
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
    |> String.replace(~r/[^[:alnum:]]+/u, "-")
    |> String.trim("-")
    |> IOP.inspect
  end

  def unslugify(slug) do
    slug
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
