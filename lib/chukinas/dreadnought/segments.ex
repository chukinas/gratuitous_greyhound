alias Chukinas.Dreadnought.{Command, Segments, Segment}
alias Chukinas.Geometry.{Rect}

defmodule Segments do

  # *** *******************************
  # *** API

  def init(command_queue, start_pose, %Rect{} = arena) do
    starts_inbounds? = get_inbounds_checker(arena)
    command_queue
    |> Stream.scan(start_pose, &Command.get_move_segments/2)
    |> Stream.take_while(starts_inbounds?)
    |> Stream.concat()
    |> Enum.to_list()
  end

  # *** *******************************
  # *** PRIVATE

  defp get_inbounds_checker(arena) do
    fn segments ->
      pose = segments |> List.first() |> Segment.get_start_pose()
      arena |> Rect.contains?(pose)
    end
  end
end
