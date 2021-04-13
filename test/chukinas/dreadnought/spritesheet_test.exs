ExUnit.start()

defmodule Chukinas.Dreadnought.SpritesheetTest do

  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "Spritesheet has a function called `test`" do
    Spritesheet.test("sprite_1")
    assert is_struct Spritesheet.test("sprite_1"), Sprite
  end
end
