alias Chukinas.Geometry.{Size, Position}

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
