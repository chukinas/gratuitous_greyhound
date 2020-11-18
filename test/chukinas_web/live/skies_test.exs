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
    # TODO assert current TP = 1
    # TODO select group
    # TODO click delay entry btn
    # TODO assert current TP = 1
    # TODO click complete phase
    # TODO assert current TP = 0
    # TODO assert current turn 2
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
