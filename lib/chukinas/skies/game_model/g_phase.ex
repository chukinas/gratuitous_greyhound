defmodule Chukinas.Skies.Game.Phase do

  # *** *******************************
  # *** CUSTOM ATTRIBUTES

  @first_phase :move
  @phases [
    {@first_phase,         nil},
    {:return,              nil},
    {:enter_exit,         :escort},
    {:move_escorts,       :escort},
    {:escort_stations,    :escort},
    {:aerial_combat,      :escort},
    {:peel_off,           :escort},
    {:recovery,            nil},
    {:rockets_and_bombs,  :blast_flak},
    {:flak,               :blast_flak},
    {:cohesion,            nil},
    {:approach,           :attack},
    {:engage,             :attack},
    {:burst,              :attack},
    {:break_away,         :attack},
  ]

  # *** *******************************
  # *** TYPES: game

  defstruct [
    :name,
    :parent,
    :is?,
  ]

  @type phase_name :: :move
    | :return
    | :escort
    | :enter_exit
    | :move_escorts
    | :escort_stations
    | :aerial_combat
    | :peel_off
    | :recovery
    | :blast_flak
    | :cohesion
    | :approach
    | :engage
    | :burst
    | :break_away
    | :rockets_and_bombs
    | :flak
    | :approach
    | :engage
    | :burst
    | :break_away

  @type t :: %__MODULE__{
    name: phase_name(),
    parent: phase_name() | nil,
    is?: (phase_name() -> boolean()),
  }

  @type spec_phase :: {phase_name(), nil | phase_name()}

  # *** *******************************
  # *** TYPES: for vm

  @type sub_phase :: phase_name()
  @type main_phase :: atom() | {atom(), [phase_name()]}
  @type nested_phases :: [main_phase()]

  # *** *******************************
  # *** NEW

  @spec new() :: t()
  def new() do
    @first_phase |> build()
  end

  # *** *******************************
  # *** API

  def all(), do: @phases

  @spec next(t()) :: t()
  def next(phase) do
    phase.name
    |> get_next_phase_name()
    |> build()
  end

  # *** *******************************
  # *** HELPERS

  @spec build(phase_name()) :: t()
  defp build(phase) do
    %__MODULE__{
      name: phase,
      parent: get_parent(phase),
      is?: fn p -> p == phase end,
    }
  end

  @spec get_next_phase_name(phase_name()) :: phase_name()
  defp get_next_phase_name(phase_name) do
    @phases
    |> Enum.find_index(&matching_spec?(&1, phase_name))
    |> next_index()
    |> get_phase_at()
  end

  @spec next_index(integer()) :: integer()
  defp next_index(index), do: index + 1

  @spec get_phase_at(integer()) :: phase_name()
  defp get_phase_at(index) do
    case Enum.fetch(@phases, index) do
      {:ok, {next_phase, _}} -> next_phase
      :error -> @first_phase
    end
  end

  @spec get_parent(phase_name()) :: nil | phase_name()
  defp get_parent(phase_name) do
    {_, parent} = @phases |> Enum.find(&matching_spec?(&1, phase_name))
    parent
  end

  @spec matching_spec?(spec_phase(), phase_name()) :: boolean()
  defp matching_spec?({spec_phase_name, _}, phase_name) do
    spec_phase_name == phase_name
  end

end
