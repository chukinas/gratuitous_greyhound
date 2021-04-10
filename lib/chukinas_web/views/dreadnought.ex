defmodule ChukinasWeb.DreadnoughtView do
  use ChukinasWeb, :view

  def message(%{socket: _socket} = assigns, do: block) do
    assigns =
      case assigns do
        %{button: _} -> assigns
        _ -> assigns |> Map.put(:button, false)
      end
    render_template("_message.html", assigns, block)
  end

  defp render_template(template, assigns, block) do
    assigns =
      assigns
      |> Map.new()
      |> Map.put(:inner_content, block)
    render template, assigns
  end

  def unit("red_ship_2") do
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
      static_path: "images/markerAndPencilShips_small.png",
      image_size_x: 122,
      image_size_y: 57,
      svg_path: "M 73,56 49,56 22,57 2,52 0,38 19,28 l 52,2 20,6 9,7 0,5 z",
      center_x: 68,
      center_y: 44,
      min_x: 0,
      max_x: 100,
      min_y: 20,
      max_y: 57
    }
    add_centered_bounding_rect mymap
  end

  def add_centered_bounding_rect(item) when is_map(item) do
    # Returns a box whose center shares the item's center
    size_x = max(
      abs(item.center_x - item.min_x),
      abs(item.center_x - item.max_x)
    )
    |> ceil
    |> double
    size_y = max(
      abs(item.center_y - item.min_y),
      abs(item.center_y - item.max_y)
    )
    |> ceil
    |> double
    rect = %{
      x: round(item.center_x - size_x / 2),
      y: round(item.center_y - size_y / 2),
      width: size_x,
      height: size_y
    }
    Map.put item, :rect, rect
  end

  def double(val), do: 2 * val
end

# https://bernheisel.com/blog/phoenix-liveview-and-views
# https://www.wyeworks.com/blog/2020/03/03/breaking-up-a-phoenix-live-view/
# https://fullstackphoenix.com/tutorials/nested-templates-and-layouts-in-phoenix-framework
