ExUnit.start()

defmodule Chukinas.Dreadnought.SpritesTest do

  use ExUnit.Case, async: true
  use Chukinas.TestHelpers

  test "Sprites has a function called `test`" do
    Sprites.test("sprite_1")
    assert is_struct Sprites.test("sprite_1"), Sprite
  end
end
