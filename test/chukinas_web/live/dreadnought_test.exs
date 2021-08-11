defmodule ChukinasWeb.DreadnoughtLiveTest do
  use ChukinasWeb.ConnCase

  import Phoenix.LiveViewTest

  # *** *******************************
  # *** TESTS

  test "Redirect / to /dreadnought", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~ "/dreadnought"
  end

  test "Gallery from Homepage", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dreadnought")
    assert view
    |> element("#link-gallery")
    |> render_click() =~ "Gallery"
  end

  test "Quick Demo", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dreadnought")
    view
    |> element("#link-demo")
    |> render_click()
    assert has_element?(view, "#player_turn_component")
    assert has_element?(view, "#unit-1")
  end

  # *** *******************************
  # *** ASSERTS - GENERAL HTML

  #defp assert_element(view, selector) do
  #  assert has_element?(view, selector)
  #  view
  #end

  #defp refute_element(view, selector, text_filter \\ nil) do
  #  refute has_element?(view, selector, text_filter)
  #  view
  #end

end
