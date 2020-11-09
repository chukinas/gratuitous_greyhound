defmodule Chukinas.Skies.Game do
  alias Chukinas.Skies.Spec
  alias Chukinas.Skies.Game.{Fighter}

  def init(map_id) do
    state = Spec.build(map_id)
    # TODO temp
    fighters = Enum.map(0..2, Fighter.new())
  end

end
