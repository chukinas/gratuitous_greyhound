alias Chukinas.Svg.ViewBox
alias Chukinas.Geometry.{Path, Position}

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

  # *** *******************************
  # *** PRIVATE
  # TODO this is no longer private. Try making it so again. If not, move to API section

  def apply_margin(viewbox) do
    add_margin = fn size -> size + 2 * viewbox.margin end
    viewbox
    |> Position.subtract(viewbox.margin, viewbox.margin)
    |> Map.update!(:width, add_margin)
    |> Map.update!(:height, add_margin)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl String.Chars do

    def to_string(viewbox) do
      viewbox = ViewBox.apply_margin viewbox
      "#{viewbox.x} #{viewbox.y} #{viewbox.width} #{viewbox.height}"
    end
  end

end
