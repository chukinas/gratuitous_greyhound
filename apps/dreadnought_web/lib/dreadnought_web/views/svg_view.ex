defmodule DreadnoughtWeb.SvgView do

    use DreadnoughtWeb, :view
    use Spatial.LinearAlgebra
    use Spatial.Math
    use Spatial.PositionOrientationSize
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

  defp render_circle(%{x: cx, y: cy} = _position, radius, attrs) do
    content_tag(:circle, nil, Keyword.merge(attrs, r: radius, cx: cx, cy: cy))
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
    [render_origin_marker() | render_mount_markers(sprite_spec)]
  end

  defp render_origin_marker do
    _render_marker(position_origin(), "red")
  end

  defp render_mount_markers(sprite_spec) when is_sprite_spec(sprite_spec) do
    sprite_spec
    |> Sprite.from_sprite_spec
    |> Sprite.mounts
    |> Enum.map(&render_mount_marker/1)
  end

  defp render_mount_marker(position) when has_position(position) do
    _render_marker(position, "blue")
  end

  defp _render_marker(position, bg_color) do
    render_circle(position, 4, opacity: 0.7, fill: bg_color, stroke: "white")
  end

end
