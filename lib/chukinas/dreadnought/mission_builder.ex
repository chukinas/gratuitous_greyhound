alias Chukinas.Dreadnought.{Mission, Unit, Command, CommandQueue, CommandIds, MissionBuilder}
alias Chukinas.Geometry.{Pose}

defmodule MissionBuilder do

  def demo() do
    Mission.new()
    |> Mission.set_arena(1000, 750)
    |> Mission.put(Unit.new(2, start_pose: Pose.new(0, 0, 45)))
    |> Mission.put(CommandQueue.new 2, [Command.new(id: 1, angle: -40, state: :in_hand)])
    |> IOP.inspect("demo mission!!!")
    |> Mission.issue_command(CommandIds.new 2, 1, 5)
  end
end
