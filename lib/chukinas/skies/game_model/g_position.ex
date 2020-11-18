defmodule Chukinas.Skies.Position do

  @type generic_direction :: :nose | :tail | :flank
  @type specific_direction :: :nose | :tail | :left | :right

  @spec to_generic(specific_direction()) :: generic_direction()
  def to_generic(direction) do
    case direction do
      :right -> :flank
      :left  -> :flank
      other -> other
    end
  end
end
