defmodule Chukinas.Skies.Game.Squadron do
  alias Chukinas.Skies.Game.{Hit, Location}

  # *** *******************************
  # *** TYPES

  @type airframe :: :bf109 | :bf110 | :fw190

  @type fighter :: %{
    id: integer(),
    airframe: airframe(),
    pilot_name: String.t(),
    hits: [Hit.t()],
    start_turn_location: Location.t(),
    move_location: Location.t(),
    end_turn_location: Location.t(),
    state: :not_avail | :pending | :selected | :complete,
  }

  @type group :: [fighter()]

  @type t :: group()

  # *** *******************************
  # *** NEW

  # TODO JJC new or init?
  @spec new() :: t()
  def new() do
    1..6
    |> Enum.map(&new_fighter/1)
  end

  @spec new_fighter(integer()) :: fighter()
  defp new_fighter(id) do
    names = ~w(Bill Ted RedBaron John Steve TheRock TheHulk)
    %{
      id: id,
      airframe: :bf109,
      # TODO
      pilot_name: Enum.at(names, id),
      hits: [],
      start_turn_location: :not_entered,
      move_location: nil,
      end_turn_location: nil,
      state: :pending,
    }
  end

  # *** *******************************
  # *** HELPERS

  # def can_delay_entry()

  @spec group(t()) :: [group()]
  def group(fighters) do
    fighters
    |> Enum.group_by(&({&1.start_turn_location, &1.move_location, &1.state}))
    |> Map.values()
  end

  # def group_by_spec(fighter) do

  #   {&1.start_turn_location, &1.move_location, &1.state}
  # end

end
