defmodule Chukinas.Skies.Game.FighterGroup do

  alias Chukinas.Skies.Game.{Fighter, IdAndState, Location}

  # *** *******************************
  # *** TYPES

  @type fighters :: [Fighter.t()]

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :fighter_ids, fighters()
    field :state, IdAndState.state()
    field :current_location, Location.t()
    field :from_location, Location.t()
    field :to_location, Location.t()
    field :count, integer()
  end

  # *** *******************************
  # *** BUILD

  @spec build(fighters()) :: t()
  def build([f | _] = fighters) do
    id = fighters
    |> Enum.map(&(&1.id))
    |> Enum.min()
    %__MODULE__{
      id: id,
      fighter_ids: IdAndState.get_list_of_ids(fighters),
      state: f.state,
      current_location: Fighter.get_current_location(f),
      from_location: f.from_location,
      to_location: f.to_location,
      count: Enum.count(fighters),
    }
  end

  # *** *******************************
  # *** API

  @spec select(t()) :: t()
  def select(group) do
    state = case group.state do
      :not_avail -> :not_avail
      _ -> :selected
    end
    %{group | state: state}
  end

  @spec unselect(t()) :: t()
  def unselect(group) do
    state = case group.state do
      :selected -> :pending
      _ -> group.state
    end
    %{group | state: state}
  end

end
