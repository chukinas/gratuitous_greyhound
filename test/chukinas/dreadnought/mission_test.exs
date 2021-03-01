ExUnit.start()

defmodule MissionTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers
  alias Chukinas.Dreadnought.CommandIds

  test "Issue Command" do
    mission = mission()
    new_mission =
      mission
      |> Mission.issue_command(CommandIds.new(1, 1, 1))

    actual_end_pose =
      new_mission
      |> Mission.segment(1, 1)
      |> Segment.end_pose()
    expected_end_pose = Pose.new(100, 500, 0)
    assert match_numerical_map? expected_end_pose, actual_end_pose

    # actual_hand_ids =
    #   new_mission
    #   |> Mission.deck(1)
    #   |> Deck.hand()
    #   |> Enum.map(&(&1.id))
    # expected_hand_ids = [2, 3, 4, 5, 6]
    # assert match_numerical_map? expected_hand_ids, actual_hand_ids

    # actual_discard_ids =
    #   new_mission
    #   |> Mission.deck(1)
    #   |> Deck.discards()
    #   |> Enum.map(&(&1.id))
    # expected_discard_ids = [1]
    # assert match_numerical_map? expected_discard_ids, actual_discard_ids
  end

  defp mission() do
    Mission.new()
    |> Mission.put(unit())
    |> Mission.put(deck())
    |> Mission.set_arena(arena())
  end
  defp unit(), do: Unit.new(1, start_pose: Pose.new(0, 500, 0))
  defp deck(), do: CommandQueue.new 1, [Command.new(id: 1, state: :in_hand)]
  defp arena(), do: Rect.new(1000, 1000)
end
