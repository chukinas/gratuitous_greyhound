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
    view
    |> assert_turn(1)
    |> assert_tp(1)
    |> delay_entry()
    |> assert_tp(0)
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
    view
  end
  defp assert_turn(view, turn_number) do
    assert element(view, "#current_turn") |> render() =~ "#{turn_number}"
    view
  end
  defp assert_tp(view, tp) do
    assert element(view, "#avail_tp") |> render() =~ "#{tp}"
    view
  end

  test "(un)select", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    refute has_element?(view, "#group_1 .select_group")
    toggle_fighter(view, 2)
    refute element(view, "#fighter_2") |> render() =~ "checked"
    view
    |> delay_entry()
    |> assert_turn(1)
    |> select_group(2)
    |> delay_entry()
    |> assert_turn(2)
    |> assert_tp(0)
  end

end
