alias Chukinas.Sessions.RoomName

defmodule RoomName do

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

  def pretty(slug) do
    slug
    |> String.split("-")
    |> Stream.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
