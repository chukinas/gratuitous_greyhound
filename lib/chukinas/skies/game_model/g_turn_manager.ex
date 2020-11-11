defmodule Chukinas.Skies.Game.TurnManager do

  def init() do
    %{
      turn: 1,
      max_turn: 7,
      phase: List.first(get_phases()),
    }
  end

  def advance_to_next_phase(turn_mgr) do
    {turn_delta, phase} = get_next_phase(turn_mgr.phase)
    turn = turn_mgr.turn + turn_delta
    Map.merge(turn_mgr, %{turn: turn, phase: phase})
  end

  defp get_next_phase(current_phase) do
    phases = get_phases()
    current_phase_index = Enum.find_index(phases, &(&1 == current_phase))
    case Enum.fetch(phases, current_phase_index + 1) do
      {:ok, next_phase} -> {0, next_phase}
      :error -> {1, List.first(phases)}
    end
  end

  defp get_phases() do
    [
      :move,
      :return,
      :escort,
      :recovery,
      :blast_flak,
      :cohesion,
      {:attack, :approach},
      {:attack, :engage},
      {:attack, :burst},
      {:attack, :break_away},
    ]
  end

end
