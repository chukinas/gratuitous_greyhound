defmodule Dreadnought.Core.Mission.Builder do

  use Dreadnought.Core.Mission.Spec
  alias Dreadnought.Core.Mission

  defmacro __using__(_opts) do
    quote do

      alias Dreadnought.Core.Mission.Builder

      @behaviour Dreadnought.Core.Mission.Builder

      @impl Dreadnought.Core.Mission.Builder
      def mission_spec(mission_name) when is_binary(mission_name) do
        new_mission_spec(__MODULE__, mission_name)
      end

    end
  end

  @callback build(mission_name :: String.t) :: Mission.t

  @callback mission_spec(mission_name :: String.t) :: mission_spec

  def build({implemenation, mission_name} = mission_spec) when is_mission_spec(mission_spec) do
    apply(implemenation, :build, [mission_name])
  end

end
