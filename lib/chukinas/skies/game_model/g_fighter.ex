defmodule Chukinas.Skies.Game.Fighter do
  alias Chukinas.Skies.Game.Hit

  @type type :: :bf109 | :bf110 | :fw190
  @type fighter :: %{
    id: integer(),
    type: type(),
    pilot_name: String.t(),
    # TODO define:
    hits: [Hit.t()],
    # TODO define a new Location module with types
    start_turn_location: any(),
    end_turn_location: any()
  }

  @spec new(integer()) :: fighter()
  def new(id) do
    %{
      id: id,
      type: :bf109,
      # TODO
      pilot_name: "Bill",
      hits: [],
      start_turn_location: :not_entered,
      end_turn_location: nil,
    }
  end

  def move(fighter, location) do
    %{fighter | location: location}
  end

end
