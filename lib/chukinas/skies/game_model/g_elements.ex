defmodule Chukinas.Skies.Game.Elements do

  # *** *******************************
  # *** TYPES

  @type bomber_location :: {integer(), integer()}

  @type bomber_element :: [bomber_location()]

  @type t :: [bomber_element()]

  # *** *******************************
  # *** SPACES AND SPECS

  @spec new(any()) :: t()
  def new({1, "a"}) do
    [
      [
        {2, 2}, {3, 2},
        {2, 3},
        {2, 4},
      ]
    ]
  end
  def new({1, "b"}) do
    [
      [
        {2, 2},
        {2, 3},
        {2, 4},
        {2, 5},
        {2, 6},
      ]
    ]
  end

end
