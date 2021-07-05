alias Chukinas.PositionOrientationSize.{Size, Position}
alias Chukinas.Util.Precision

defmodule Size do
  @moduledoc"""
  Simple struct for describing width and height
  """

  use TypedStruct

  typedstruct enforce: true do
    field :width, number()
    field :height, number()
  end

  # *** *******************************
  # *** NEW

  def new(%{width: width, height: height}) do
    %__MODULE__{
      width: width,
      height: height
    }
  end

  def new(width, height) do
    %__MODULE__{
      width: width,
      height: height
    }
  end

  def rounded(width, height) do
    %__MODULE__{
      width: Precision.coerce_int(width),
      height: Precision.coerce_int(height)
    }
  end

  def from_position(a) do
    %__MODULE__{
      width: a.x,
      height: a.y
    }
  end

  def from_positions(a, b) do
    %__MODULE__{
      width: abs(a.x - b.x),
      height: abs(a.y - b.y)
    }
  end

  # *** *******************************
  # *** API FOR ACTING ON WIDTH/HEIGHT KEYS

  def add(a, b) do
    %{a | width: a.width + b.width, height: a.height + b.height}
  end

  def subtract(a, b) do
    Enum.reduce([:width, :height], a, fn key, new_size ->
      Map.update!(new_size, key, & &1 - b[key])
    end)
  end

  def halve(size), do: multiply(size, 0.5)
  def double(size), do: multiply(size, 2)

  def multiply(size, value) do
    Enum.reduce([:width, :height], size, fn key, new_size ->
      Map.update!(new_size, key, & &1 * value)
    end)
  end

  # *** *******************************
  # *** GETTERS

  def width(%{width: val}), do: val

  def height(%{height: val}), do: val

  # *** *******************************
  # *** CONVERSIONS

  def to_position(size) do
    Position.new size.width, size.height
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    require IOP
    def inspect(size, opts) do
      concat [
        IOP.color("#Size<"),
        IOP.doc(size.width |> round),
        ", ",
        IOP.doc(size.height |> round),
        IOP.color(">")
      ]
    end
  end
end
