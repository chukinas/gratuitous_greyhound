defmodule Dreadnought.Core.Mission.Builder do

  use Dreadnought.Core.Mission.Spec
  alias Dreadnought.Core.Mission

  @callback new(mission_name :: String.t) :: Mission.t

  @callback mission_spec(mission_name :: String.t) :: mission_spec

end
