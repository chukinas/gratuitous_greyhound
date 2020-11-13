defmodule Chukinas.Skies.Game.Fighter do
  # TODO rename Fighters?
  alias Chukinas.Skies.Game.Hit

  # TODO rename from type to... model? aircraft?
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
  @type group :: [fighter()]
  @type t :: group()

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

  # TODO where is this used?
  @spec group(fighter()) :: fighter()
  def move(fighter, location) do
    %{fighter | location: location}
  end

  @spec group(t()) :: [group()]
  def group(fighters) do
    fighters
    |> Enum.chunk_every(2)
  end

end
