defmodule Statechart.MonikerTest do

  use ExUnit.Case
  alias Statechart.Node.Moniker

  test "Moniker Transition Steps: to self" do
    from = to = Moniker.root()
    expected_transition_steps =
      [
        start: from
      ]
    assert expected_transition_steps == Moniker.transition_steps(from, to)
  end

  test "Moniker Transition Steps: to grandchild" do
    to =
      Moniker.root()
      |> Moniker.down(:a)
      |> Moniker.down(:b)
    expected_transition_steps =
      [
        start: from,
        down: Moniker.parent(to),
        down: to,
      ]
    assert expected_transition_steps == Moniker.transition_steps(from, to)
  end

  test "Moniker Transition Steps: to sibling" do
    from =
      Moniker.root()
      |> Moniker.down(:a)
    to =
      Moniker.root()
      |> Moniker.down(:x)
    expected_transition_steps =
      [
        start: from,
        up: Moniker.root(),
        down: to
      ]
    assert expected_transition_steps == Moniker.transition_steps(from, to)

  end

end
