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
  # *** API

  def add(size1, size2) do
    %__MODULE__{
      width: size1.width + size2.width,
      height: size1.height + size2.height
    }
  end

  def subtract(size1, size2) do
    %__MODULE__{
      width: size1.width - size2.width,
      height: size1.height - size2.height
    }
  end

  def halve(size) do
    %__MODULE__{
      width: size.width / 2,
      height: size.height / 2
    }
  end

  def multiply(size, value) do
    %__MODULE__{
      width: size.width * value,
      height: size.height * value
    }
  end

  def to_position(size) do
    Position.new size.width, size.height
  end

end
