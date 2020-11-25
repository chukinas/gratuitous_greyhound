defmodule Chukinas.Skies.Game.FighterGroup do
  alias Chukinas.Skies.Game.{Fighter}
  alias Chukinas.Skies.Game.IdAndState

  # *** *******************************
  # *** TYPES

  defstruct [
    :id,
    :fighter_ids,
    :state,
    :current_location,
  ]

  @type fighters :: [Fighter.t()]
  @type fighter_func :: (Fighter.t() -> Fighter.t())

  @type t :: %__MODULE__{
    id: integer(),
    fighter_ids: fighters(),
    state: IdAndState.state(),
    current_location: Location.t(),
  }

  # *** *******************************
  # *** NEW

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
    }
  end

  @spec build_groups(fighters()) :: [t()]
  def build_groups(fighters) do
    fighters
    |> Enum.group_by(&({&1.start_turn_location, &1.move_location, &1.state}))
    |> Map.values()
    |> Enum.map(&build/1)
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
