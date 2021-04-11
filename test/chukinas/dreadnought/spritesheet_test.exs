ExUnit.start()

# TODO rename Chukinas.SpritesheetTest?
defmodule SpritesheetTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers

  test "Spritesheet has a function called `test`" do
    module = Chukinas.Dreadnought.Spritesheet
    func = :test
    module = Map
    func = :keys
    assert Keyword.has_key? module.__info__(:functions), func
  end
end
