defmodule ChukinasWeb.SkiesLiveTest do
  use ChukinasWeb.ConnCase
  alias Chukinas.Skies.Game.Box

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, skies_live, disconnected_html} = live(conn, "/skies")
    assert disconnected_html =~ "Skies"
    assert render(skies_live) =~ "Skies"
  end

  test "End Phase btn when all groups are complete", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    view
    |> assert_turn(1)
    |> assert_current_phase("Move")
    |> assert_current_phase("Return", false)
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

  defp assert_current_phase(view, phase_name, assert? \\ true) do
    has_element = element(view, "#current_phase") |> render() =~ phase_name
    assert has_element |> flip_bool(assert?)
    view
  end
  defp flip_bool(orig, keep) do
    if keep, do: orig, else: !orig
  end
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
  defp assert_turn(view, turn_number) do
    assert has_element?(view, "#current_turn", "#{turn_number}")
    view
  end
  defp assert_tactical_points(view, tp) do
    assert has_element?(view, "#avail_tp", "#{tp}")
    view
  end
  defp assert_group_has_unselect_btn(view, group_id, assert? \\ true) do
    has_element = has_element?(view, "#group_#{group_id} .unselect_group")
    assert flip_bool(has_element, assert?)
    view
  end
  defp group_has_no_select_btn(view, group_id) do
    assert has_element?(view, "#group_#{group_id} .select_group")
    view
  end
  defp assert_disabled(view, element_id) do
    assert has_element?(view, "##{element_id}[disabled]")
    view
  end
  # defp assert_element(view, selector, text_filter \\ nil) do
  #   assert has_element?(view, selector, text_filter)
  #   view
  # end
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
  def move_position(view, location) do
    {_, _, _, id} = Box.to_strings(location)
    view
    |> element("#" <> id)
    |> render_click()
    view
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
    # TODO extract
    [1, 2]
    |> Enum.each(&(group_has_no_select_btn(view, &1)))
    view
    |> select_group(1)
    |> assert_group_has_unselect_btn(1)
    |> assert_group_has_unselect_btn(2, false)
  end

  test "enter board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    view
    |> move_position({:nose, :preapproach, :low})
    # TODO assert group 1 token is in nose/low
    # TODO click end phase
    # TODO assert turn 2
  end

  # TODO future tests/tasks:
  # delay entry shouldn't be anything special. It should be a location like any other
  # Unify selection of locations and tp cost

end
