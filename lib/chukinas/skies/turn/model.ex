defmodule Chukinas.Skies.Game.Turn do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :number, integer(), default: 1
    field :max, integer(), default: 7
    field :end_game?, boolean(), default: false
  end

  # *** *******************************
  # *** NEW

  @spec new() :: t()
  def new(), do: %__MODULE__{}

  # *** *******************************
  # *** API

  def next(%__MODULE__{} = turn), do: build(turn.number + 1, turn.max)

  # *** *******************************
  # *** HELPERS

  @spec build(integer(), integer()) :: t()
  defp build(turn, max) do
    %__MODULE__{
      number: turn,
      max: max,
      end_game?: turn > max,
    }
  end

end
