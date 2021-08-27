# TODO Svg is probable the wrong namespace for this
defmodule Dreadnought.Svg.Position do

  def put_attrs(keywords \\ [], position) when is_list(keywords) do
    Keyword.merge(keywords, attrs(position))
  end

  def attrs(%{} = position) do
    position
    |> Map.take(~w/x y/a)
    |> Enum.into([])
  end

end
