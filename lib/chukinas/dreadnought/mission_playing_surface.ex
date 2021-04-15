alias Chukinas.Dreadnought.{Mission.PlayingSurface}

defmodule PlayingSurface do
  @moduledoc """
  The game's playing surface, with islands, border, etc
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :world, Size.t()
    field :margin, Size.t()
    field :arena, Rect.t()
    field :islands, [Island.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(%{
    world: _world,
    margin: _margin,
    arena: _arena,
    islands: _islands
  } = playing_surface) do
    struct!(__MODULE__, playing_surface)
  end
end
