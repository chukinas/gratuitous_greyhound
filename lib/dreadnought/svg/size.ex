defmodule Dreadnought.Svg.Size do

  def put(keywords \\ [], size) when is_list(keywords) do
    Keyword.merge(keywords, attrs(size))
  end

  def attrs(%{} = size) do
    size
    |> Map.take(~w/width height/a)
    |> Enum.into([])
  end

end
