defmodule Chukinas.Skies.Spec do
  alias Chukinas.Skies.Spec.{Map, Boxes}

  def build(map_id) do
    %{
      spaces: Map.spaces(map_id),
      elements: Map.elements(map_id),
      boxes: Boxes.build()
    }
  end

end
