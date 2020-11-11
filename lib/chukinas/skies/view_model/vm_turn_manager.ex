defmodule Chukinas.Skies.ViewModel.TurnManager do
  # alias Chukinas.Skies.Game.TurnManager

  def render(turn_mgr) do
    # Map.get_and_update!(turn_mgr, :phase, &phase_to_string/1)
    turn_mgr
  end

  # defp phase_to_string(phase) when is_atom(phase) do
  #   phase
  #   |> Atom.to_string()
  #   |> String.capitalize()
  # end

  # defp phase_to_string(phase) do
  #   [main_phase, sub_phase] = phase
  #   |> Tuple.to_list()
  #   |> Enum.map(&phase_to_string/1)
  #   "#{main_phase}: #{sub_phase}"
  # end

end
