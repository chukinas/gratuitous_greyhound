defmodule Dreadnought.SpritesTest do

  use ExUnit.Case, async: true
  alias Dreadnought.Sprite

  test "Sprites has a function called `test`" do
    # TODO don't call this directly
    # TODO test shouldn't be a valid sprite_spec?
    Sprite.Importer.test("sprite_1")
    assert is_struct Sprite.Importer.test("sprite_1"), Sprite
  end
end
