defmodule Chukinas.Skies.Game.Position do

  # *** *******************************
  # *** TYPES

  @type generic_direction :: :nose | :tail | :flank
  @type specific_direction :: :nose | :tail | :left | :right
  @type approach_type :: :preapproach | :approach
  @type box_type :: :return | approach_type()
  @type altitude :: :high | :level | :low
  @type mode :: :determined | :evasive
  @type box :: :dogfight | :not_entered | :exited
    | {specific_direction(), :preapproach | :approach, altitude()}
    | {specific_direction(), :return, altitude(), mode()}



  # *** *******************************
  # *** API

  @spec to_generic(specific_direction()) :: generic_direction()
  def to_generic(direction) do
    case direction do
      :right -> :flank
      :left  -> :flank
      other -> other
    end
  end
end
