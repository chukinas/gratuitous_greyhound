alias Chukinas.Dreadnought.Unit.Builder

defmodule Builder do

  def form("red_ship_2") do
    mymap = %{
      mounts: [
        %{
          id: 1,
          type: :turret,
          x: 70,
          y: 44
        },
        %{
          id: 2,
          type: :turret,
          x: 22,
          y: 44
        }
      ],
      static_path: "/images/markerAndPencilShips_small.png",
      image_size_x: 122,
      image_size_y: 57,
      svg_path: "M 73,56 49,56 22,57 2,52 0,38 19,28 l 52,2 20,6 9,7 0,5 z",
      # These are used merely for getting more useful calculated values?
      # TODO, also, many of these are just good guesses.
      # When I auto-generate this with macros, they'll be exact.
      center_x: 68,
      center_y: 44,
      min_x: 0,
      max_x: 100,
      min_y: 20,
      max_y: 57
    }
    add_centered_bounding_rect mymap
  end

  defp add_centered_bounding_rect(item) when is_map(item) do
    # Returns a box whose center shares the item's center
    half_x_size = max(
      abs(item.center_x - item.min_x),
      abs(item.center_x - item.max_x)
    )
    |> ceil
    half_y_size = max(
      abs(item.center_y - item.min_y),
      abs(item.center_y - item.max_y)
    )
    |> ceil
    rect = %{
      x: round(item.center_x - half_x_size),
      y: round(item.center_y - half_y_size),
      half_width: half_x_size,
      half_height: half_y_size,
      width: half_x_size |> double,
      height: half_y_size |> double,
    }
    Map.put item, :rect, rect
  end

  defp double(val), do: 2 * val
end
