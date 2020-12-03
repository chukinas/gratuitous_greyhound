defmodule Chukinas.Skies.Game.Fighter do

  alias Chukinas.Skies.Game.{Bomber, Box, Hit, IdAndState, Location, Phase}

  # *** *******************************
  # *** TYPES

  use TypedStruct

  @type airframe :: :bf109 | :bf110 | :fw190
  @type attack_mode :: :determined | :evasive

  typedstruct enforce: true do
    field :id, integer()
    field :pilot_name, String.t()
    field :airframe, airframe(), default: :bf109
    field :hits, [Hit.t()], default: []
    field :box_start, Box.id(), default: :notentered
    field :box_move, Box.id() | nil, default: nil
    field :box_end, Box.id() | nil, default: nil
    field :attack_bomber_id, Bomber.id() | nil, default: nil
    field :attack_mode, attack_mode(), default: :determined
    field :state, IdAndState.state(), default: :selected
    # These are fields that exist just for grouping and rendering
    field :phase, Phase.phase_name(), default: :move
    field :from_location, Location.t() | nil, default: nil
    field :to_location, Location.t() | nil, default: nil
    field :grouping, any(), default: nil
  end

  # *** *******************************
  # *** NEW

  @spec new(integer()) :: t()
  def new(id) do
    # names = ~w(Bill Ted RedBaron John Steve TheRock TheHulk)
    %__MODULE__{
      id: id,
      # pilot_name: Enum.at(names, id, "no name"),
      pilot_name: "Billy",
    }
    |> update()
  end

  # *** *******************************
  # *** API :: t()

  @spec start_phase(t(), Phase.phase_name()) :: t()
  def start_phase(fighter, phase_name) do
    %{fighter | phase: phase_name} |> update()
  end

  @spec select(t()) :: t()
  def select(fighter) do
    %{fighter | state: :selected}
  end

  @spec unselect(t()) :: t()
  def unselect(fighter) do
    state = case fighter.state do
      :selected -> :pending
      current_state -> current_state
    end
    %{fighter | state: state}
  end

  def toggle_select(%__MODULE__{state: state} = f) do
    %{f | state: case state do
      :selected -> :pending
      _ -> :selected
    end}
  end

  @spec do_not_move(t()) :: t()
  def do_not_move(%__MODULE__{box_start: box} = f) do
    move(f, box) |> update()
  end

  @spec move(t(), Box.id) :: t()
  def move(%__MODULE__{} = f, box_id) do
    %{f | box_move: box_id} |> complete()
  end

  # TODO remove this in favor of start_phase
  def next_turn(%__MODULE__{} = fighter) do
    %{fighter |
      box_start: get_current_location(fighter),
      box_move: nil,
      state: :pending
    }
  end

  @spec attack(t(), Bomber.id) :: t()
  def attack(%__MODULE__{} = f, bomber_id) do
    %{f | attack_bomber_id: bomber_id}
    |> complete()
  end

  # *** *******************************
  # *** API :: other

  @spec get_move(t()) :: Box.fighter_move()
  def get_move(%__MODULE__{} = fighter) do
    {fighter.box_start, fighter.box_move}
  end
  def selected?(%__MODULE__{state: :selected}), do: true
  def selected?(_), do: false
  def delayed_entry?(%__MODULE__{} = fighter) do
    fighter.box_move == :notentered
  end
  def get_current_location(%__MODULE__{} = fighter) do
    fighter.box_move || fighter.box_start
  end
  def available_this_turn?(%__MODULE__{state: state}) do
    state != :not_avail
  end

  # *** *******************************
  # *** HELPERS

  # TODO better name?
  # TODO this should be called privately in any func that updates state
  @spec update(t()) :: t()
  defp update(fighter), do: do_update(fighter, fighter.phase)

  # TODO better name?
  @spec do_update(t(), Phase.phase_name()) :: t()
  defp do_update(f, :move) do
    %{f |
      from_location: f.box_start,
      to_location: f.box_move,
      grouping: {
        f.state,
        f.box_start,
        f.box_move,
      },
    }
  end
  defp do_update(f, :approach) do
    %{f |
      from_location: f.box_move,
      to_location: f.attack_bomber_id,
      grouping: {
        f.state,
        f.box_move,
        f.attack_bomber_id,
        f.attack_mode,
        f.box_end,
      },
    }
  end
  defp do_update(f, _) do
    %{f |
      from_location: f.box_start,
      to_location: get_current_location(f),
      grouping: nil,
    }
  end

  defp complete(%__MODULE__{} = fighter) do
    %{fighter | state: :complete} |> update()
  end

end
