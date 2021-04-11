ExUnit.start()

defmodule Chukinas.Dreadnought.SpritesheetTest do

  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "Spritesheet has a function called `test`" do
    module = Spritesheet
    func = :test
    assert Keyword.has_key? module.__info__(:functions), func
    assert is_map Spritesheet.test("sprite_1")
  end
end
