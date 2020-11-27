defmodule Chukinas.Skies.Game.Turn do

  # *** *******************************
  # *** TYPES

  defstruct [
    :current,
    :max_turn,
    :end_game?,
  ]

  # TODO typedstruct
  @type t :: %__MODULE__{
    current: integer(),
    max_turn: integer(),
    end_game?: boolean(),
  }

  # *** *******************************
  # *** NEW

  @spec new() :: t()
  def new(), do: build(1, 7)

  # *** *******************************
  # *** API

  def next(%__MODULE__{} = tm), do: build(tm.turn + 1, tm.max_turn)

  # *** *******************************
  # *** HELPERS

  @spec build(integer(), integer()) :: t()
  defp build(turn, max_turn) do
    %__MODULE__{
      current: turn,
      max_turn: max_turn,
      end_game?: turn > max_turn,
    }
  end

end
