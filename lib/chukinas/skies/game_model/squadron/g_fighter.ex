defmodule Chukinas.Skies.Game.Fighter do
  alias Chukinas.Skies.Game.{Hit, Location}
  alias Chukinas.Skies.Game.IdAndState

  # *** *******************************
  # *** TYPES

  defstruct [
    :id,
    :airframe,
    :pilot_name,
    :hits,
    :box_start,
    :box_end,
    :end_turn_location,
    :state,
  ]

  @type airframe :: :bf109 | :bf110 | :fw190


  @type t :: %__MODULE__{
    id: integer(),
    airframe: airframe(),
    pilot_name: String.t(),
    hits: [Hit.t()],
    box_start: Location.t(),
    box_end: Location.t(),
    end_turn_location: Location.t(),
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
      box_start: :not_entered,
      box_end: nil,
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

  @spec move(t(), Box.id) :: t()
  def move(%__MODULE__{} = f, box_id) do
    %{f | box_end: box_id}
    |> complete()
  end

  def do_not_move(%__MODULE__{box_start: box} = f) do
    move(f, box)
  end

  @spec get_move(t()) :: Box.fighter_move()
  def get_move(%__MODULE__{} = fighter) do
    {fighter.box_start, fighter.box_end}
  end

  def selected?(%__MODULE__{state: :selected}), do: true
  def selected?(_), do: false
  def delayed_entry?(%__MODULE__{} = fighter) do
    fighter.box_end == :not_entered
  end
  def complete(%__MODULE__{} = fighter) do
    %{fighter | state: :complete}
  end

  def get_current_location(%__MODULE__{} = fighter) do
    fighter.box_end || fighter.box_start
  end

  def start_new_turn(%__MODULE__{} = fighter) do
    %{fighter |
      box_start: get_current_location(fighter),
      box_end: nil,
      state: :pending
    }
  end

end
