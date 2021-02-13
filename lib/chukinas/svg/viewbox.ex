alias Chukinas.Svg.ViewBox
alias Chukinas.Geometry.{Path, Position}
alias Chukinas.Util.Precision

defmodule ViewBox do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :x, number()
    field :y, number()
    field :width, number()
    field :height, number()
    field :margin, number(), enforce: false
  end

  # *** *******************************
  # *** NEW

  @spec new(Path.t()) :: t()
  def new(path) do
    struct(__MODULE__, Path.get_bounding_rect path)
    |> Position.subtract(Path.get_start_pose path)
    |> Map.put(:margin, 10)
  end

  def apply_margin(viewbox) do
    add_margin = fn size -> size + 2 * viewbox.margin end
    viewbox
    # TODO use subtract/1
    |> Position.subtract(viewbox.margin, viewbox.margin)
    |> Map.update!(:width, add_margin)
    |> Map.update!(:height, add_margin)
  end

  def get_position(viewbox) do
    viewbox |> apply_margin() |> Map.take([:x, :y])
  end

  def values_to_int(viewbox) do
    viewbox |> Precision.values_to_int([:x, :y, :width, :height, :margin])
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl String.Chars do

    def to_string(viewbox) do
      viewbox = ViewBox.apply_margin(viewbox) |> ViewBox.values_to_int()
      "#{viewbox.x} #{viewbox.y} #{viewbox.width} #{viewbox.height}"
    end
  end

end
