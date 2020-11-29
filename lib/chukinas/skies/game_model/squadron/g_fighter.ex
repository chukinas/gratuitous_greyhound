defmodule Chukinas.Skies.Game.Fighter do
  alias Chukinas.Skies.Game.{Box, Hit}
  alias Chukinas.Skies.Game.IdAndState

  # *** *******************************
  # *** TYPES

  defstruct [
    :id,
    :airframe,
    :pilot_name,
    :hits,
    :box_start,
    :box_move,
    :end_turn_location,
    :state,
  ]

  @type airframe :: :bf109 | :bf110 | :fw190


  @type t :: %__MODULE__{
    id: integer(),
    airframe: airframe(),
    pilot_name: String.t(),
    hits: [Hit.t()],
    box_start: Box.id(),
    # TODO rename box move?
    box_move: nil | Box.id(),
    # TODO rename box end?
    end_turn_location: nil | Box.id(),
    state: IdAndState.state(),
  }

  # *** *******************************
  # *** NEW

  @spec new(integer()) :: t()
  def new(id) do
    names = ~w(Bill Ted RedBaron John Steve TheRock TheHulk)
    %__MODULE__{
      id: id,
      airframe: :bf109,
      pilot_name: Enum.at(names, id, "no name"),
      hits: [],
      box_start: :notentered,
      box_move: nil,
      end_turn_location: nil,
      state: :selected,
    }
  end

  # *** *******************************
  # *** API

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
    move(f, box)
  end

  @spec move(t(), Box.id) :: t()
  def move(%__MODULE__{} = f, box_id) do
    %{f | box_move: box_id}
    |> complete()
  end

  @spec get_move(t()) :: Box.fighter_move()
  def get_move(%__MODULE__{} = fighter) do
    {fighter.box_start, fighter.box_move}
  end

  def selected?(%__MODULE__{state: :selected}), do: true
  def selected?(_), do: false
  def delayed_entry?(%__MODULE__{} = fighter) do
    fighter.box_move == :notentered
  end
  def complete(%__MODULE__{} = fighter) do
    %{fighter | state: :complete}
  end

  def get_current_location(%__MODULE__{} = fighter) do
    fighter.box_move || fighter.box_start
  end

  def start_new_turn(%__MODULE__{} = fighter) do
    %{fighter |
      box_start: get_current_location(fighter),
      box_move: nil,
      state: :pending
    }
  end

  def available_this_turn?(%__MODULE__{state: state}) do
    state != :not_avail
  end

end
