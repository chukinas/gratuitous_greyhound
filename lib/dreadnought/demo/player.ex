defmodule Dreadnought.Demo.Player do

    use Dreadnought.Core.Mission.Spec
  alias Dreadnought.Core.Player

  def build(mission_spec, uuid) when is_mission_spec(mission_spec) do
    %Player{
      type: :human,
      uuid: uuid,
      name: "Demo Player",
      mission_spec: mission_spec,
      ready?: true
    }
  end

end
