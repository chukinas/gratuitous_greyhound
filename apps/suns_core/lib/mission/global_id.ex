
defmodule SunsCore.Mission.GlobalId do

  @type symbol :: :battlegroup | :object | :ship
  @type id :: integer
  @type t :: {symbol, id}

  for symbol <- ~w/battlegroup object ship/a do
    def unquote(symbol)(id), do: {unquote(symbol), id}
  end

end

