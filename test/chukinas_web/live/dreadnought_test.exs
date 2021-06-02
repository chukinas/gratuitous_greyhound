defmodule ChukinasWeb.DreadnoughtLiveTest do
  use ChukinasWeb.ConnCase

  #import Phoenix.LiveViewTest

  # *** *******************************
  # *** ACTIONS

  # defp click_command(view, unit_id, command_id) do
  #   view
  #   |> element("#command-#{unit_id}-#{command_id}")
  #   |> render_click()
  #   view
  # end

  # # *** *******************************
  # # *** ASSERTS - GAME HOUSEKEEPING

  # defp assert_phase(view, phase_name, assert? \\ true) do
  #   assert has_element?(view, "#current_phase", phase_name)
  #   |> flip_bool(assert?)
  #   view
  # end
  # defp assert_turn(view, turn_number) do
  #   assert has_element?(view, "#current_turn", "#{turn_number}")
  #   view
  # end
  # defp assert_tactical_points(view, tp) do
  #   assert has_element?(view, "#avail_tp", "#{tp}")
  #   view
  # end

  # # *** *******************************
  # # *** ASSERTS - SQUADRON

  # defp assert_group_has_unselect_btn(view, group_id, assert? \\ true) do
  #   has_element = has_element?(view, "#group_#{group_id} .unselect_group")
  #   assert flip_bool(has_element, assert?)
  #   view
  # end
  # defp group_has_no_select_btn(view, group_id) do
  #   assert has_element?(view, "#group_#{group_id} .select_group"); view
  # end
  # defp assert_group_from(view, group_id, from_text) do
  #   # TODO use has_element instead?
  #   assert view
  #   |> has_element?("#group_#{group_id} .from_location", from_text)
  #   # assert view
  #   # |> element("#group_#{group_id} .from_location")
  #   # |> render() =~ from_text
  #   view
  # end
  # defp assert_group_to(view, group_id, to_text) do
  #   assert view
  #   |> element("#group_#{group_id} .to_location")
  #   |> render() =~ to_text
  #   view
  # end

  # # *** *******************************
  # # *** ASSERTS - PAWNS

  # defp assert_group_in_box(view, group_id, box_id) do
  #   group_selector = "#pawn_group_" <> Integer.to_string(group_id)
  #   box_selector = "#" <> Box.id_to_uiid(box_id)
  #   assert has_element?(view, "#{box_selector} #{group_selector}")
  #   view
  # end

  # # *** *******************************
  # # *** ASSERTS - GENERAL HTML

  # defp assert_disabled(view, element_id) do
  #   assert has_element?(view, "##{element_id}[disabled]")
  #   view
  # end
  # # TODO element is bad term (means bomber group)
  # defp assert_element(view, element_id) do
  #   assert has_element?(view, "#" <> element_id)
  #   view
  # end
  # defp refute_element(view, selector, text_filter \\ nil) do
  #   refute has_element?(view, selector, text_filter)
  #   view
  # end
  # defp assert_ids_appear_in_order(view, id1, id2) do
  #   assert render(view)
  #   |> String.split("id=\"#{id1}\"")
  #   |> Enum.at(1)
  #   |> String.contains?("id=\"#{id2}\"")
  #   view
  # end


  # # *** *******************************
  # # *** HELPERS

  # defp flip_bool(orig, keep) do
  #   if keep, do: orig, else: !orig
  # end

  # *** *******************************
  # *** TESTS

  #test "Two ships on screen", %{conn: conn} do
  #  {:ok, view, _html} = live(conn, "/dreadnought/grid")
  #  assert has_element?(view, "#unit-1")
  #  assert has_element?(view, "#unit-2")
  #end

  #   test "Start game.", %{conn: conn} do
  #     {:ok, view, _html} = live(conn, "/dreadnought/disclaimer")
  #     element(view, "#message-button") |> render_click()
  #     assert has_element?(view, "#unit--2")
  #   end

end
