defmodule ChukinasWeb.SkiesLiveTest do
  use ChukinasWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, skies_live, disconnected_html} = live(conn, "/skies")
    assert disconnected_html =~ "Skies"
    assert render(skies_live) =~ "Skies"
  end

  test "Next Turn", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    assert view
    |> element("#current_phase")
    |> render() =~ "Move"
    refute view
    |> element("#current_phase")
    |> render() =~ "Return"
    view
    |> element("#next_phase")
    |> render_click()
    assert view
    |> element("#current_phase")
    |> render() =~ "Return"
  end

  test "delay entry", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    view |> assert_turn(1)
    assert element(view, "#avail_tp") |> render() =~ "1"
    view |> delay_entry()
    assert element(view, "#avail_tp") |> render() =~ "0"
  end

  defp delay_entry(view) do
    view |> element("#delay_entry") |> render_click()
    view
  end
  defp click_next_phase(view) do
    element(view, "#next_phase") |> render_click()
  end
  defp toggle_fighter(view, fighter_id) do
    element(view, "#fighter_#{fighter_id}") |> render_click()
  end
  defp select_group(view, group_id) do
    element(view, "#group_#{group_id} .select_group") |> render_click()
  end
  defp assert_turn(view, turn_number) do
    assert element(view, "#current_turn") |> render() =~ "#{turn_number}"
    view
  end

  test "(un)select", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    refute has_element?(view, "#group_1 .select_group")
    toggle_fighter(view, 1)
    refute element(view, "#fighter_1") |> render() =~ "checked"
    view
    |> delay_entry()
    |> assert_turn(1)
    assert has_element?(view, "#group_2")
    select_group(view, 1)
    delay_entry(view)
    # TODO assert turn 2
    # TODO check tp 0
  end

end
