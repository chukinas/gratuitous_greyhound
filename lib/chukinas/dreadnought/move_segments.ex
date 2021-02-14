alias Chukinas.Dreadnought.{Arena, Command}

defmodule Chukinas.Dreadnought.MovementSegments do

  # *** *******************************
  # *** API

  def init(command_queue, start_pose, arena) do
    starts_inbounds? = Arena.get_inbounds_checker(arena)
    command_queue
    # TODO get move segments needs a second param that's the pose
    |> Stream.scan(start_pose, &Command.get_move_segments/2)
    |> Stream.take_while(starts_inbounds?)
    # TODO replace with Stream.concat
    |> Enum.to_list()
    |> List.flatten()
  end

  # *** *******************************
  # *** PRIVATE

end
