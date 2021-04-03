alias Chukinas.Geometry.{Size}

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

end
