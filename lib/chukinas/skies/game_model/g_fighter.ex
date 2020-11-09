defmodule Chukinas.Skies.Game.Fighter do

  def new(id) do
    %{
      id: id,
      current_location: :not_entered,
      current_command: nil,
      type: :bf109,
      hits: [],
    }
  end

  def move(fighter, location) do
    %{fighter | location: location}
  end

end
