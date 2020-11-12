defmodule Chukinas.Skies.ViewModel.TurnManager do
  alias Chukinas.Skies.Game.TurnManager

  @type phase :: %{
    name: String.t(),
    status: (:other | :in_progress | :sub_in_progress),
    subphases: [phase()]
  }
  @type t :: %{
    turn: integer(),
    max_turn: integer(),
    phases: [phase()]
  }

  @spec build(TurnManager.t()) :: t()
  def build(turn_mgr) do
    %{
      turn: turn_mgr.turn,
      max_turn: turn_mgr.max_turn,
      phases: dummy_phases(),
    }
  end

  @spec dummy_phases() :: [phase()]
  defp dummy_phases() do
    [
      %{name: "First", status: :other, subphases: []},
      %{name: "Second", status: :other, subphases: []},
      %{name: "Second", status: :other, subphases: []},
      %{name: "Third", status: :sub_in_progress, subphases: [
        %{name: "Stuss", status: :other, subphases: []},
        %{name: "And", status: :in_progress, subphases: []},
        %{name: "Nonsense", status: :other, subphases: []},
      ]},
      %{name: "Fourth", status: :other, subphases: []},
    ]
  end

  # @spec phase_to_string(TurnManager.phase_name()) :: String.t
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
