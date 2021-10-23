defmodule SunsCore.Mission.Controller do
  @moduledoc """
  Specifies who (system (i.e. the game) or a player) controls a battlegroup or object
  """

  @type system :: 0
  @type player_id :: 1..4
  @type t :: system | player_id

end
