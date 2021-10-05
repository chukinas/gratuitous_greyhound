defmodule Spatial do

  defmodule Vector do
    # TODO Should I make this available at this level (Spatial.Vector) or one higher (Spatial.Type.Vector) ?
    @type t :: Spatial.LinearAlgebra.Vector.t
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def rect do
    quote do
      alias Spatial.Geometry.Rect
    end
  end

  def pos do
    quote do
      use Spatial.PositionOrientationSize
    end
  end

end
