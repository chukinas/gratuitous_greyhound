defmodule Chukinas.Skies.Game do
  alias Chukinas.Skies.Spec

  def init(map_id) do
    Spec.build(map_id)
  end

end
