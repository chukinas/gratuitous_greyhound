alias Chukinas.Sessions.Room.Name

defmodule ChukinasWeb.Plugs.SanitizeRoomName do
  #alias Phoenix.Controller
  #alias Plug.Conn

  def init(opts) do
    opts
  end

  def call(%{:path_params => %{"room" => raw_room_name}} = conn, _opts) do
    case Name.slugify(raw_room_name) do
      ^raw_room_name ->
        conn
      room_slug ->
        path =
          conn.request_path
          |> URI.decode()
          |> String.replace(raw_room_name, room_slug)
        conn
        |> Controller.redirect(to: path)
        |> Conn.halt()
    end
  end

  def call(conn, _opts), do: conn

end
