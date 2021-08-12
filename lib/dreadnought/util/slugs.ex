defmodule Dreadnought.Util.Slugs do

  def slugify(nil), do: ""
  def slugify(string) do
    string
    |> String.downcase()
    |> String.replace(~r/[^[:alnum:]]+/u, "-")
    |> String.trim("-")
  end

  def pretty(slug) do
    slug
    |> String.split("-")
    |> Stream.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
