defmodule Chukinas.Skies.Game.TurnManager do

  defstruct [:turn, :max_turn, :phase]

  @type phase_name :: :move
    | :return
    | :escort
    | :recovery
    | :blast_flak
    | :cohesion
    | :approach
    | :engage
    | :burst
    | :break_away
  @type phase :: phase_name() | {phase_name(), [phase_name()]}
  @type phases :: [phase()]
  @type t :: %__MODULE__{
    turn: integer(),
    max_turn: integer(),
    phase: phase_name(),
  }

  def init() do
    %{
      turn: 1,
      max_turn: 7,
      phase: :burst,
      # phase: List.first(get_phases()),
    }
  end

  @spec advance_to_next_phase(t()) :: t()
  def advance_to_next_phase(turn_mgr) do
    next_phase = get_next_phase(turn_mgr.phase)
    next_turn = turn_mgr.turn + cond do
      next_phase == get_first_phase() -> 1
      true -> 0
    end
    Map.merge(turn_mgr, %{turn: next_turn, phase: next_phase})
  end

  @spec get_next_phase(phase_name()) :: phase_name()
  defp get_next_phase(current_phase) do
    flat_phases = get_phases() |> to_flat_list()
    current_phase_index = Enum.find_index(flat_phases, &(&1 == current_phase))
    case Enum.fetch(flat_phases, current_phase_index + 1) do
      {:ok, next_phase} -> next_phase
      :error -> List.first(flat_phases)
    end
  end

  @spec to_flat_list(phases()) :: [phase_name()]
  def to_flat_list(phases) do
    Enum.flat_map(phases, &flatten_phase/1)
  end

  @spec flatten_phase(phase()) :: [phase_name()]
  defp flatten_phase(phase) when is_atom(phase), do: [phase]
  defp flatten_phase({_, phases}), do: phases

  @spec get_first_phase() :: phase_name()
  defp get_first_phase() do
    get_phases()
    |> to_flat_list()
    |> List.first()
  end

  @spec get_phases() :: phases()
  def get_phases() do
    [
      :move,
      :return,
      :escort,
      :recovery,
      :blast_flak,
      :cohesion,
      {:approach, [
        :engage,
        :burst,
        :break_away,
      ]}
    ]
  end

end
