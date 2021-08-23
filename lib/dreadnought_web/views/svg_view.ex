defmodule DreadnoughtWeb.SvgView do

    use DreadnoughtWeb, :view
    use Dreadnought.LinearAlgebra
    use Dreadnought.Math
    use Dreadnought.PositionOrientationSize
  alias Dreadnought.Svg

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

  def render_clippath(id, coords) do
    polygon = render_polygon(coords)
    content_tag(:clipPath, polygon,
      id: id
    )
  end

end
