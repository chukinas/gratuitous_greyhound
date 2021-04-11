alias Chukinas.Dreadnought.Spritesheet.Parser

defmodule Parser do

  # Return list of spritesheets
  def parse_svg(svg_as_map) do
    svg_as_map["svg"]["#content"]["g"]
    |> coerce_list
    |> Enum.map(&parse_spritesheet/1)
    |> Enum.filter(&is_map/1)
  end

  # Each layer (spritesheet) in the Inkscape file contains
  # all the sprite for a single spritesheet image.
  defp parse_spritesheet(layer) do
    spritesheet =
      layer["#content"]["g"]
      |> coerce_list
      |> Stream.map(&parse_sublayer/1)
      |> Enum.group_by(& &1.type)
      |> Map.put_new(:sprite, [])
    if Map.has_key?(spritesheet, :image) do
      %{
        image: List.first(spritesheet.image),
        sprites: spritesheet.sprite
      }
    else
      nil
    end
  end

  # Each sublayer in the Inkscape file is either a link to the
  # spritesheet image (only 1 per layer) or a collection of svg shapes
  # describing the clip path, origin, and mountings (zero, one or many)
  # of a single sprite from that spritesheet.
  defp parse_sublayer(nil) do
    %{
      type: nil,
    }
  end
  defp parse_sublayer(%{"#content" => nil}), do: parse_sublayer(nil)
  defp parse_sublayer(%{"#content" => %{"image" => image}}) do
    pathname = get_href(image)
    %{
      type: :image,
      path: %{
        name: pathname,
        extension: Path.extname(pathname),
        root: Path.rootname(pathname)
      },
      x: image["-x"],
      y: image["-y"],
      width: image["-width"],
      height: image["-height"]
    }
  end
  defp parse_sublayer(%{
    "#content" => %{
      "path" => path,
      "circle" => markers} } = sublayer) when is_map(path) do
    %{
      type: :sprite,
      clip_name: get_label(sublayer),
      clip_path: path["-d"]
    }
    |> Map.merge(parse_markers(markers))
  end

  # Return a map, with a key for the origin marker and
  # a key for the list of optional mounting points.
  defp parse_markers(markers) do
    marker_map =
      markers
      |> coerce_list
      |> Stream.map(&parse_marker/1)
      |> Enum.group_by(& &1.type)
      |> Map.put_new(:mounting, [])
    %{
      origin: List.first(marker_map.origin),
      mountings: marker_map.mounting
    }
  end

  # Return either an origin or mounting marker.
  defp parse_marker(marker) do
    type = case get_label(marker) do
      "origin" -> %{type: :origin}
      "mounting_" <> num -> %{type: :mounting, num: num}
    end
    %{
      x: attr(marker, "cx"),
      y: attr(marker, "cy")
    }
    |> Map.merge(type)
  end

  # XmlToMap appends a dash in front of tag attributes
  defp attr(map, attr), do: map["-" <> attr]

  # Some of the Inkscape attributes are rather lengthy.
  # These utilities allow me to access those attributes more easily.
  defp get_href(map), do: get_val_from_key_ending_in(map, "href")
  defp get_label(map), do: get_val_from_key_ending_in(map, "label")
  defp get_val_from_key_ending_in(map, key_ending) do
    key = map
    |> Map.keys
    |> Enum.find(& String.ends_with? &1, key_ending)
    map[key]
  end

  # Some tags, like the group ("g") can have zero to many items.
  # XmlToMap creates a list of maps if there are more than one item,
  # but it creates a single map if there is only one item.
  # This function allows me to always works with list where
  # lists are possible.
  defp coerce_list(term) when is_list(term), do: term
  defp coerce_list(term), do: [term]

end
