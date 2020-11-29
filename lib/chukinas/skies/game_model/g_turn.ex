defmodule Chukinas.Skies.Game.Turn do

  # *** *******************************
  # *** TYPES

  defstruct [
    :number,
    :max,
    :end_game?,
  ]

  # TODO typedstruct
  @type t :: %__MODULE__{
    number: integer(),
    max: integer(),
    end_game?: boolean(),
  }

  # *** *******************************
  # *** NEW

  @spec new() :: t()
  def new(), do: build(1, 7)

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
