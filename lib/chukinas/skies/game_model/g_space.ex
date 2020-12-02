defmodule Chukinas.Skies.Game.Space do

  alias Chukinas.Skies.Game.{Bomber, Box}

  # *** *******************************
  # *** TYPES

  @type id() :: {integer(), integer()}

  use TypedStruct

  typedstruct do
    field :id, id(), enforce: true
    field :x, integer(), enforce: true
    field :y, integer(), enforce: true
    field :lethal_level, integer(), enforce: true
  end

  # *** *******************************
  # *** NEW

  @spec new(id(), integer()) :: t()
  def new({x, y} = id, lethal_level) do
    %__MODULE__{
      id: id,
      x: x,
      y: y,
      lethal_level: lethal_level,
    }
  end

  # *** *******************************
  # *** API

  @spec space_to_bomber(id(), Box.position()) :: Bomber.id()
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
