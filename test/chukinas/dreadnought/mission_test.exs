ExUnit.start()

defmodule MissionTest do
  use ExUnit.Case, async: true
  use DreadnoughtHelpers
  alias Chukinas.Dreadnought.CommandIds

  test "Issue Command" do
    mission =
      Mission.new()
      |> Mission.issue_command(CommandIds.new(2, 1, 1))
      |> IO.inspect(label: "mission!")

    actual_end_pose =
      mission
      |> Mission.segment(1)
      |> Segment.end_pose()
    expected_end_pose = Pose.new(100, 100, 0)
    assert match_numerical_map? expected_end_pose, actual_end_pose

    # actual_hand_ids =
    #   mission
    #   |> Mission.deck(1)
    #   |> Deck.hand()
    #   |> Enum.map(&(&1.id))
    # expected_hand_ids = [2, 3, 4, 5, 6]
    # assert match_numerical_map? expected_hand_ids, actual_hand_ids

    # actual_discard_ids =
    #   mission
    #   |> Mission.deck(1)
    #   |> Deck.discards()
    #   |> Enum.map(&(&1.id))
    # expected_discard_ids = [1]
    # assert match_numerical_map? expected_discard_ids, actual_discard_ids
  end
end
