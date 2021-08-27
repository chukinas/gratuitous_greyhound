defmodule DreadnoughtWeb.SvgView do

    use DreadnoughtWeb, :view
    use Dreadnought.LinearAlgebra
    use Dreadnought.Math
    use Dreadnought.PositionOrientationSize
    use Dreadnought.Sprite.Spec
  alias Dreadnought.Sprite.Improved, as: Sprite
  alias Dreadnought.Svg

  # *** *******************************
  # *** ELEMENTS

  # TODO add size guard
  def render_image(href, size, opts \\ []) when is_list(opts) do
    attrs =
      opts
      |> Keyword.put(:href, href)
      |> Keyword.put(:width, size.width)
      |> Keyword.put(:height, size.height)
    content_tag(:image, nil, attrs)
  end

  def render_polygon(coords, opts \\ []) when is_list(opts) do
    content_tag(:polygon, nil,
      Keyword.put(opts, :points, Svg.polygon_points_string_from_coords(coords))
    )
  end

  def render_use(href_id, opts \\ []) when is_list(opts) do
    attrs =
      opts
      |> Keyword.put(:href, "#" <> href_id)
    content_tag(:use, nil, attrs)
  end

  def render_use_with_pose(href_id, pose, opts \\ []) when has_pose(pose) and is_list(opts) do
    opts =
      opts
      |> Keyword.merge(pose |> Svg.pose_to_attrs)
    render_use(href_id, opts)
  end

  def render_clippath_polygon(id, coords) do
    polygon = render_polygon(coords)
    content_tag(:clipPath, polygon,
      id: id
    )
  end

  def render_clippath_use(id, href_id) when is_binary(href_id) do
    use_element = render_use(href_id)
    content_tag(:clipPath, use_element,
      id: id
    )
  end

  defp render_circle(position, radius, attrs)
  when has_position(position) do
    attrs =
      attrs
      |> Keyword.put(:r, radius)
      |> Svg.Position.put_attrs(position)
    content_tag(:circle, nil, attrs)
  end

  # *** *******************************
  # *** DROPSHADOW

  def render_dropshadow_def, do: render("dropshadow_def.html", [])

  def render_dropshadow_filter do
    # TODO DRY
    ~e"""
    filter="url(#paperdropshadow)"
    """
  end

  defp put_dropshadow_filter(attrs \\ []) when is_list(attrs) do
    Keyword.put(attrs, :filter, dropshadow_url())
  end

  defp dropshadow_url, do: "url(#paperdropshadow)"

  def render_dropshadow_use(href_id) when is_binary(href_id) do
    render_use(href_id, put_dropshadow_filter())
  end

  # *** *******************************
  # *** MARKERS

  def render_markers(sprite_spec) when is_sprite_spec(sprite_spec) do
    IO.puts "rendering markers1"
    render_origin_marker()
  end

  def render_origin_marker do
    render_circle(position_origin(), 4, fill: "red")
  end

  def render_mount_markers(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite_spec
    |> Sprite.from_sprite_spec
    |> Sprite.mounts
    |> Enum.map(&render_mount_marker/1)
  end

  def render_mount_marker(position) when has_position(position) do
    render_circle(position, 4, fill: "blue")
  end

end
