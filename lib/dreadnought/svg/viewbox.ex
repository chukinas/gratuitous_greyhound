defmodule Dreadnought.Svg.Viewbox do

  alias Dreadnought.BoundingRect

  # *** *******************************
  # *** CONSTRUCTORS

  def put_attr(keywords \\ [], item_with_bounding_rect) when is_list(keywords) do
    [attr(item_with_bounding_rect) | keywords]
  end

  def attr(item_with_bounding_rect) do
    {:viewBox, attr_val(item_with_bounding_rect)}
  end

  # *** *******************************
  # *** HELPERS

  @spec attr_val(BoundingRect.t) :: String.t
  defp attr_val(item_with_bounding_rect) do
    rect = BoundingRect.of(item_with_bounding_rect)
    ~w/x y width height/a
    |> Enum.map(&Map.fetch!(rect, &1))
    |> Enum.join(" ")
  end

end
