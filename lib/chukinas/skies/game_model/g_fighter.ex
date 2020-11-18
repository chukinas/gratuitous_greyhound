defmodule Chukinas.Skies.Game.Fighter do
  alias Chukinas.Skies.Game.{Hit, Location}

  # *** *******************************
  # *** TYPES

  defstruct [
    :id,
    :group_id,
    :airframe,
    :pilot_name,
    :hits,
    :start_turn_location,
    :move_location,
    :end_turn_location,
    :state,
  ]

  @type airframe :: :bf109 | :bf110 | :fw190

  @type state :: :not_avail | :pending | :selected | :complete

  @type t :: %__MODULE__{
    id: integer(),
    group_id: integer(),
    airframe: airframe(),
    pilot_name: String.t(),
    hits: [Hit.t()],
    start_turn_location: Location.t(),
    move_location: Location.t(),
    end_turn_location: Location.t(),
    state: state(),
  }

  # *** *******************************
  # *** NEW

  @spec new(integer()) :: t()
  def new(id) do
    names = ~w(Bill Ted RedBaron John Steve TheRock TheHulk)
    %__MODULE__{
      id: id,
      group_id: 1,
      airframe: :bf109,
      pilot_name: Enum.at(names, id, "no name"),
      hits: [],
      start_turn_location: :not_entered,
      move_location: nil,
      end_turn_location: nil,
      state: :selected,
    }
  end

  # *** *******************************
  # *** HELPERS

  def maybe_select(fighter, group_id) do
    cond do
      fighter.group_id == group_id -> %{fighter | state: :selected}
      fighter.state == :selected -> %{fighter | state: :pending}
    end
  end

  # *** *******************************
  # *** API

  def toggle_select(%__MODULE__{state: state} = f) do
    %{f | state: case state do
      :selected -> :pending
      _ -> :selected
    end}
  end

  def selected?(%__MODULE__{state: :selected}), do: true
  def selected?(_), do: false
  def delay_entry(%__MODULE__{} = f), do: %{f | move_location: :not_entered}
  def delayed_entry?(%__MODULE__{move_location: loc}), do: loc == :not_entered

end
