alias Chukinas.Geometry.{Size, Position}
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

  def from_positions(a, b) do
    %__MODULE__{
      width: abs(a.x - b.x),
      height: abs(a.y - b.y)
    }
  end

  # *** *******************************
  # *** API FOR ACTING ON WIDTH/HEIGHT KEYS

  def add(a, b) do
    Enum.reduce([:width, :height], a, fn key, new_size ->
      Map.update!(new_size, key, & &1 + b[key])
    end)
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
  # *** CONVERSIONS

  def to_position(size) do
    Position.new size.width, size.height
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

#  defimpl Inspect do
#    import Inspect.Algebra
#    def inspect(size, opts) do
#      col = fn string -> color(string, :cust_struct, opts) end
#      #fields = [
#      #  position: size |> Vector.from_position,
#      #  size: size |> Position.from_size |> Vector.new
#      #]
#      fields = {size.width, size.height}
#      concat [
#        col.("#Size<"),
#        to_doc(fields, opts),
#        col.(">")
#      ]
#    end
#  end

end
