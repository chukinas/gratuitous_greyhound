defmodule Dreadnought.Core.SpritesTest do

  use ExUnit.Case, async: true
  alias Dreadnought.Core.Sprite
  alias Dreadnought.Core.Sprites

  test "Sprites has a function called `test`" do
    Sprites.test("sprite_1")
    assert is_struct Sprites.test("sprite_1"), Sprite
  end
end
