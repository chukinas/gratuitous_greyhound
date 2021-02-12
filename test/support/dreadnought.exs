defmodule DreadnoughtHelpers do
  defmacro __using__(_options) do
    quote do
      alias Chukinas.Geometry.Path
      alias Chukinas.Svg
      import DreadnoughtHelpers, only: :functions
    end
  end
end
