ExUnit.start()

defmodule Chukinas.Dreadnought.SpritesheetTest do

  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "Spritesheet has a function called `test`" do
    assert is_map Spritesheet.test("sprite_1")
  end
end
