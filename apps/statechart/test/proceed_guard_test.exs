defmodule Statechart.ProceedGuardTest do

  use ExUnit.Case
  import Statechart.TestSupport.Helpers
  alias Statechart.TestSupport.ThirdTimeACharm.HitTheButton
  alias Statechart.TestSupport.ThirdTimeACharm.PlatitudeMachine

  test "ProceedGuard" do
    hit_the_button = &PlatitudeMachine.transition(&1, HitTheButton.new())
    PlatitudeMachine.new()
    |> hit_the_button.() |> assert_state(:not_yet)
    |> hit_the_button.() |> assert_state(:not_yet)
    |> hit_the_button.() |> assert_state(:yaayy)
  end

end
