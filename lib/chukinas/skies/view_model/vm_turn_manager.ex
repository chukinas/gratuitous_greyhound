defmodule Chukinas.Skies.ViewModel.TurnManager do
  alias Chukinas.Skies.Game.TurnManager, as: TM

  # *** *******************************
  # *** TYPES

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

  # *** *******************************
  # *** BUILDERS

  @spec build(TurnManager.t()) :: t()
  def build(turn_mgr) do
    %{
      turn: turn_mgr.turn,
      max_turn: turn_mgr.max_turn,
      phases: build_vm_phases(turn_mgr.phase),
    }
  end

  # @spec dummy_phases() :: [phase()]
  # defp dummy_phases() do
  #   [
  #     %{name: "First", status: :other, subphases: []},
  #     %{name: "Second", status: :other, subphases: []},
  #     %{name: "Second", status: :other, subphases: []},
  #     %{name: "Third", status: :sub_in_progress, subphases: [
  #       %{name: "Stuss", status: :other, subphases: []},
  #       %{name: "And", status: :in_progress, subphases: []},
  #       %{name: "Nonsense", status: :other, subphases: []},
  #     ]},
  #     %{name: "Fourth", status: :other, subphases: []},
  #   ]
  # end

  @spec build_vm_phases(TM.phase_name()) :: [phase()]
  defp build_vm_phases(current_phase) do
    TM.get_phases()
    |> Enum.map(&(phase_to_vm(&1, current_phase)))
  end

  @spec phase_to_vm(TM.phase_name(), TM.phase_name()) :: phase()
  defp phase_to_vm(phase, current_phase) when is_atom(phase) do
    %{
      name: phase_to_string(phase),
      status: case current_phase do
        ^phase -> :in_progress
        _ -> :other
      end,
      subphases: []
    }
  end

  defp phase_to_vm({phase_name, subphases}, current_phase) do
    vm_subphases = Enum.map(subphases, &(phase_to_vm(&1, current_phase)))
    vm_status = cond do
      Enum.any?(vm_subphases, fn x -> x.status == :in_progress end) -> :sub_in_progress
      true -> :other
    end
    %{
      name: phase_to_string(phase_name),
      status: vm_status,
      subphases: Enum.map(subphases, &(phase_to_vm(&1, current_phase)))
    }
  end

  @spec phase_to_string(TM.phase_name()) :: String.t
  defp phase_to_string(phase) when is_atom(phase) do
    case phase do
      :blast_flak -> "Blast & Flak"
      :break_away -> "Break Away"
      _ -> phase
        |> Atom.to_string()
        |> String.capitalize()
    end
  end

  # defp phase_to_string(phase) do
  #   [main_phase, sub_phase] = phase
  #   |> Tuple.to_list()
  #   |> Enum.map(&phase_to_string/1)
  #   "#{main_phase}: #{sub_phase}"
  # end

end
