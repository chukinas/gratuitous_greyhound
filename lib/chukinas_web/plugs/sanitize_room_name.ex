defmodule ChukinasWeb.Plugs.SanitizeRoomName do
  # TODO how to add documentation?
  alias Phoenix.Controller
  alias Plug.Conn

  defmacro __using__(_opts) do
    quote do
      import ChukinasWeb.Plugs.SanitizeRoomName, only: [
        slugify: 1,
        unslugify: 1,
        count_alnum: 1,
        to_alnum: 1
      ]
    end
  end

  def init(opts) do
    opts
  end

  def call(%{:path_params => %{"room" => room_name}} = conn, _opts) do
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

  def slugify(nil), do: ""
  def slugify(string) do
    string
    |> String.downcase()
    |> String.replace(~r/[^[:alnum:]]+/u, "-")
    |> String.trim("-")
  end

  def to_alnum(string) do
    string
    |> slugify
    |> String.replace("-", "")
  end

  def count_alnum(string) do
    string
    |> to_alnum
    |> String.length
  end

  def unslugify(slug) do
    slug
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
