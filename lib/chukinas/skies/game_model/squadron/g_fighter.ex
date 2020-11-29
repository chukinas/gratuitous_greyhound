defmodule Chukinas.Skies.Game.Fighter do

  alias Chukinas.Skies.Game.{Box, Hit}
  alias Chukinas.Skies.Game.IdAndState

  # *** *******************************
  # *** TYPES

  use TypedStruct

  @type airframe :: :bf109 | :bf110 | :fw190

  typedstruct enforce: true do
    field :id, integer(), enforce: true
    field :airframe, airframe(), default: :bf109
    field :pilot_name, String.t(), default: ""
    field :hits, [Hit.t()], default: []
    field :box_start, Box.id(), default: :notentered
    field :box_move, Box.id() | nil, default: nil
    field :box_end, Box.id() | nil, default: nil
    field :state, IdAndState.state(), default: :selected
  end

  # *** *******************************
  # *** NEW

  @spec new(integer()) :: t()
  def new(id) do
    names = ~w(Bill Ted RedBaron John Steve TheRock TheHulk)
    %__MODULE__{
      id: id,
      pilot_name: Enum.at(names, id, "no name"),
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

  def next_turn(%__MODULE__{} = fighter) do
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
