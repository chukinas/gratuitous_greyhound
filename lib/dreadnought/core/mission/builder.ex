defmodule Dreadnought.Core.Mission.Builder do

  alias Dreadnought.Core.Mission

  @callback new(mission_name :: String.t) :: Mission.t

end
