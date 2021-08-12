ExUnit.start()

defmodule Dreadnought.Core.SpritesTest do

  use ExUnit.Case, async: true
  use Dreadnought.TestHelpers

  test "Sprites has a function called `test`" do
    Sprites.test("sprite_1")
    assert is_struct Sprites.test("sprite_1"), Sprite
  end
end
