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

  test "Delay entry", %{conn: conn} do
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

end
