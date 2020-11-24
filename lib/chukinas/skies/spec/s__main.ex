defmodule Chukinas.Skies.Spec do
  alias Chukinas.Skies.Spec.Map

  def build(map_id) do
    {spaces, elements} = Map.build(map_id)
    %{
      spaces: spaces,
      elements: elements,
    }
  end

end
