ExUnit.start()

defmodule Chukinas.Dreadnought.SpritesheetTest do

  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "Spritesheet has a function called `test`" do
    Spritesheet.test("sprite_1") |> IOP.inspect
    assert is_struct IOP.inspect(Spritesheet.test("sprite_1")), Sprite
  end
end
