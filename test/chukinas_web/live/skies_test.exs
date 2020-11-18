defmodule ChukinasWeb.SkiesLiveTest do
  use ChukinasWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, skies_live, disconnected_html} = live(conn, "/skies")
    assert disconnected_html =~ "Skies"
    assert render(skies_live) =~ "Skies"
  end

  # TODO tag with something like 'intermediary'?
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
    assert view |> element("#current_turn") |> render() =~ "1"
    assert view |> element("#current_tp") |> render() =~ "1"
    # element(view, "#group_1 .select_group") |> render_click()
    delay_entry(view)
    assert view |> element("#current_tp") |> render() =~ "0"
    click_next_phase(view)
    assert view |> element("#current_tp") |> render() =~ "0"
    assert view |> element("#current_turn") |> render() =~ "2"
    refute has_element?(view, "#delay_entry")
  end

  defp delay_entry(view), do: view |> element("#delay_entry") |> render_click()
  defp click_next_phase(view) do
    element(view, "#next_phase") |> render_click()
  end

  # test "Select Fighter Group", %{conn: conn} do
  #   {:ok, view, html} = live(conn, "/skies")
  #   view
  #   |> element("#fighter_group_1_2_3_4_5_6")
  #   |> render_submit() =~ "Move"
  #   refute view
  #   |> element("#current_phase")
  #   |> render() =~ "Return"
  #   view
  #   |> element("#next_phase")
  #   |> render_click()
  #   assert view
  #   |> element("#current_phase")
  #   |> render() =~ "Return"
  # end


end
