defmodule ChukinasWeb.SkiesLiveTest do
  use ChukinasWeb.ConnCase
  alias Chukinas.Skies.Game.Box

  import Phoenix.LiveViewTest

  # *** *******************************
  # *** ACTIONS

  defp delay_entry(view) do
    view |> element("#delay_entry") |> render_click()
    view
  end
  defp end_phase(view) do
    element(view, "#end_phase") |> render_click()
    view
  end
  defp toggle_fighter(view, fighter_id) do
    element(view, "#fighter_#{fighter_id}") |> render_click()
    view
  end
  defp select_group(view, group_id) do
    element(view, "#group_#{group_id} .select_group") |> render_click()
    view
  end
  defp move(view, box_id) do
    view
    |> element("#" <> Box.id_to_string(box_id))
    |> render_click()
    view
  end
  defp attack_bomber(view, x, y) do
    # TODO I'll also need a test func for 'approach space'.
    # TODO Spaces should key into same attack bomber command?
    view |> element("#bomber_#{x}_#{y}") |> render_click(); view
  end

  # *** *******************************
  # *** ASSERTS - GAME HOUSEKEEPING

  defp assert_phase(view, phase_name, assert? \\ true) do
    assert has_element?(view, "#current_phase", phase_name)
    |> flip_bool(assert?)
    view
  end
  defp assert_turn(view, turn_number) do
    assert has_element?(view, "#current_turn", "#{turn_number}")
    view
  end
  defp assert_tactical_points(view, tp) do
    assert has_element?(view, "#avail_tp", "#{tp}")
    view
  end

  # *** *******************************
  # *** ASSERTS - SQUADRON

  defp assert_group_has_unselect_btn(view, group_id, assert? \\ true) do
    has_element = has_element?(view, "#group_#{group_id} .unselect_group")
    assert flip_bool(has_element, assert?)
    view
  end
  defp group_has_no_select_btn(view, group_id) do
    assert has_element?(view, "#group_#{group_id} .select_group"); view
  end
  defp assert_group_from(view, group_id, from_text) do
    # TODO use has_element instead?
    assert view
    |> has_element?("#group_#{group_id} .from_location", from_text)
    # assert view
    # |> element("#group_#{group_id} .from_location")
    # |> render() =~ from_text
    view
  end
  defp assert_group_to(view, group_id, to_text) do
    assert view
    |> element("#group_#{group_id} .to_location")
    |> render() =~ to_text
    view
  end

  # *** *******************************
  # *** ASSERTS - PAWNS

  defp assert_group_in_box(view, group_id, box_id) do
    group_selector = "#pawn_group_" <> Integer.to_string(group_id)
    box_selector = "#" <> Box.id_to_string(box_id)
    assert has_element?(view, "#{box_selector} #{group_selector}")
    view
  end

  # *** *******************************
  # *** ASSERTS - GENERAL HTML

  defp assert_disabled(view, element_id) do
    assert has_element?(view, "##{element_id}[disabled]")
    view
  end
  # TODO element is bad term (means bomber group)
  defp assert_element(view, element_id) do
    assert has_element?(view, "#" <> element_id)
    view
  end
  defp refute_element(view, selector, text_filter \\ nil) do
    refute has_element?(view, selector, text_filter)
    view
  end
  defp assert_ids_appear_in_order(view, id1, id2) do
    assert render(view)
    |> String.split("id=\"#{id1}\"")
    |> Enum.at(1)
    |> String.contains?("id=\"#{id2}\"")
    view
  end


  # *** *******************************
  # *** HELPERS

  defp flip_bool(orig, keep) do
    if keep, do: orig, else: !orig
  end

  # *** *******************************
  # *** TESTS

  test "disconnected and connected render", %{conn: conn} do
    {:ok, skies_live, disconnected_html} = live(conn, "/skies")
    assert disconnected_html =~ "Skies"
    assert render(skies_live) =~ "Skies"
  end

  test "End Phase btn when all groups are complete", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    view
    |> assert_turn(1)
    |> assert_phase("Move")
    |> assert_phase("Return", false)
    |> assert_disabled("end_phase")
    |> delay_entry()
    |> end_phase()
    |> assert_turn(2)
  end

  test "delay entry", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    view
    |> assert_turn(1)
    |> assert_tactical_points(1)
    |> delay_entry()
    |> assert_tactical_points(0)
  end

  test "(un)select", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    view
    |> refute_element("#group_1 .select_group")
    |> toggle_fighter(2)
    |> refute_element("#fighter_2", "checked")
    |> delay_entry()
    |> assert_turn(1)
    |> select_group(2)
    |> delay_entry()
    |> end_phase()
    |> assert_turn(2)
    |> assert_tactical_points(0)
  end

  test "squadron buttons and checkboxes works", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    view
    |> toggle_fighter(2)
    |> delay_entry()
    |> assert_ids_appear_in_order("group_1", "group_2")
    |> group_has_no_select_btn(1)
    |> group_has_no_select_btn(2)
    |> select_group(1)
    |> assert_group_has_unselect_btn(1)
    |> assert_group_has_unselect_btn(2, false)
  end

  test "enter board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    box = {:nose, :preapproach, :low}
    view
    |> assert_element("notentered")
    |> assert_group_in_box(1, :notentered)
    |> move(box)
    |> assert_group_in_box(1, box)
    |> assert_tactical_points(1)
    |> end_phase()
    |> assert_turn(2)
    |> assert_phase("Move")
    |> select_group(1)
    |> move({:nose, :preapproach, :high})
    |> assert_tactical_points(0)
    |> end_phase()
    |> select_group(1)
    |> move({:nose, :approach, :high})
    |> end_phase()
    |> assert_phase("Approach")
  end

  test "fighters on approach", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    view
    # *** Turn 1
    |> assert_group_from(1, "Not Yet Entered")
    |> assert_group_to(1, "Nil")
    |> move({:nose, :preapproach, :low})
    |> assert_group_to(1, "Nose/Preapproach/Low")
    |> end_phase()
    # *** Turn 2: Move
    |> select_group(1) |> move({:nose, :approach, :low})
    |> end_phase()
    # *** Turn 3: Approach
    |> assert_phase("Approach")
    |> select_group(1)
    |> attack_bomber(2, 2)
    |> assert_group_to(1, "Space (2, 2)")
  end

end

# <!-- font Germania One? Pirata One - UnifrakturCook UnifrakturMaguntia Vampiro One NewRocker stencil... Rakkas Ceviche One
# Grenze Gotisc
# ...typewriterh
# -->

# TODO Nil locations shouldn't render as Nil. What instead?
# TODO select mode
# TODO select maneuver (climb/dive, straight or roll left/right)
# TODO fighters should group correctly on approach
# TODO during attack, fighters not in approach box should be disabled
# TODO boxes should be disabled if not avail
