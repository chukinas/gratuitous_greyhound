defmodule Chukinas.Skies.ViewModel.TurnManager do
  alias Chukinas.Skies.Game.TurnManager

  @type t :: %{
    turn: integer(),
    max_turn: integer(),
    phase: String.t(),
  }

  @spec build(TurnManager.t()) :: t()
  def build(turn_mgr) do
    %{
      turn: turn_mgr.turn,
      max_turn: turn_mgr.max_turn,
      phase: phase_to_string(turn_mgr.phase)
    }
  end

  @spec phase_to_string(TurnManager.phase_name()) :: String.t
  defp phase_to_string(phase) when is_atom(phase) do
    phase
    |> Atom.to_string()
    |> String.capitalize()
  end

  # defp phase_to_string(phase) do
  #   [main_phase, sub_phase] = phase
  #   |> Tuple.to_list()
  #   |> Enum.map(&phase_to_string/1)
  #   "#{main_phase}: #{sub_phase}"
  # end

end
