defmodule Chukinas.Skies.Game.Squadron do
  alias Chukinas.Skies.Game.{Hit, Location}

  @type airframe :: :bf109 | :bf110 | :fw190
  @type fighter :: %{
    id: integer(),
    airframe: airframe(),
    pilot_name: String.t(),
    hits: [Hit.t()],
    start_turn_location: Location.t(),
    end_turn_location: Location.t()
  }
  @type group :: [fighter()]
  @type t :: group()

  @spec new(integer()) :: fighter()
  def new(id) do
    %{
      id: id,
      airframe: :bf109,
      # TODO
      pilot_name: "Bill",
      hits: [],
      start_turn_location: :not_entered,
      end_turn_location: nil,
    }
  end

  @spec group(t()) :: [group()]
  def group(fighters) do
    fighters
    |> Enum.chunk_every(2)
  end

end
