defmodule Chukinas.Skies.Spec do
  alias Chukinas.Skies.Spec.{Map, Boxes}

  def build(map) do
    %{
      spaces: Map.spaces(map),
      elements: Map.elements(map),
      boxes: Boxes.build()
    }
  end

end
