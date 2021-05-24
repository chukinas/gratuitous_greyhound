alias Chukinas.Sessions.Room.Name

defmodule Name do

  # TODO don't need this. An import statement would be fine
  #defmacro __using__(_opts) do
  #  quote do
  #    import Name, only: [
  #      slugify: 1,
  #      pretty: 1,
  #      count_alnum: 1,
  #      to_alnum: 1
  #    ]
  #  end
  #end

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
