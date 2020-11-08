defmodule Chukinas.Skies.Terms do
  @type generic_direction :: :nose, :left, :flank
  @type specific_direction :: :nose, :left, :right, :tail

  @spec to_generic(specific_direction) :: generic_direction()
  def to_generic(direction) do
    case direction do
      :right -> :flank
      :left  -> :flank
      other -> other
    end
  end
end
