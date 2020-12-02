defmodule Chukinas.Skies.Game.Spaces do

  alias Chukinas.Skies.Game.{Bomber, Box}

  # *** *******************************
  # *** TYPES

  @type id :: {integer(), integer()}

  @type t :: %{id => integer()}

  # *** *******************************
  # *** NEW

  @spec new(any()) :: t()
  def new({1, "a"}) do
    # TODO spaces should be 1-indexed
    # TODO this will affect the attack bomber method
    %{
                   {1, 0} => 1, {2, 0} => 1, {3, 0} => 1,
      {0, 1} => 1, {1, 1} => 1, {2, 1} => 2, {3, 1} => 1,
      {0, 2} => 1, {1, 2} => 2, {2, 2} => 3, {3, 2} => 1,
      {0, 3} => 1, {1, 3} => 2, {2, 3} => 2, {3, 3} => 1,
      {0, 4} => 1, {1, 4} => 1, {2, 4} => 1, {3, 4} => 1,
    }
  end
  def new({1, "b"}) do
    %{
      {0, 0} => 1, {1, 0} => 1, {2, 0} => 1, {3, 0} => 1,
      {0, 1} => 1, {1, 1} => 2, {2, 1} => 2, {3, 1} => 1,
      {0, 2} => 1, {1, 2} => 2, {2, 2} => 2, {3, 2} => 1,
      {0, 3} => 1, {1, 3} => 2, {2, 3} => 2, {3, 3} => 1,
      {0, 4} => 1, {1, 4} => 2, {2, 4} => 2, {3, 4} => 1,
      {0, 5} => 1, {1, 5} => 1, {2, 5} => 1, {3, 5} => 1,
    }
  end

  # *** *******************************
  # *** API

  def to_friendly_string({x, y}) do
    "#{x}, #{y}"
  end

  @spec space_to_bomber(id(), Box.position()) :: Bomber.location()
  def space_to_bomber({x, y}, position) do
    {dx, dy} = case position do
      :nose  -> { 0,  0}
      :left  -> { 0, -1}
      :right -> {-1,  0}
      :tail  -> {-1, -1}
    end
    {x + dx, y + dy}
  end

end
