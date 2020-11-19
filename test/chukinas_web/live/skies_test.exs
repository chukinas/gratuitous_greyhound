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
    assert element(view, "#current_turn") |> render() =~ "1"
    assert element(view, "#avail_tp") |> render() =~ "1"
    delay_entry(view)
    assert element(view, "#avail_tp") |> render() =~ "0"
    click_next_phase(view)
    assert element(view, "#avail_tp") |> render() =~ "0"
    assert element(view, "#current_turn") |> render() =~ "2"
    refute has_element?(view, "#delay_entry")
  end

  defp delay_entry(view), do: view |> element("#delay_entry") |> render_click()
  defp click_next_phase(view) do
    element(view, "#next_phase") |> render_click()
  end
  defp click_fighter(view, fighter_id) do
    element(view, "#fighter_#{fighter_id}") |> render_click()
  end

  test "(un)select", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/skies")
    # TODO assert group 1 select is not rendered
    element(view, "#fighter_1") |> render_click()
    refute element(view, "#fighter_1") |> render() =~ "checked"
    delay_entry(view)
    assert has_element?(view, "#group_2")
    # TODO select group 1
    # TODO delay entry
    # TODO click next phase
    # TODO check turn 2
    # TODO check tp 0
  end

end
