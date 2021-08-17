defmodule DreadnoughtWeb.MainLiveTest do

  use DreadnoughtWeb.ConnCase
  use Dreadnought.TestHelpers
  import Phoenix.LiveViewTest

  # *** *******************************
  # *** TESTS

  test "Redirect / to /dreadnought", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~ "/dreadnought"
  end

  test "Multiplayer from Homepage", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dreadnought")
    new_player = %{name: "Billy the Kid", mission_name: "flippy slippy"}
    view
    |> click("#link-multiplayer")
    |> assert_element("#new_player_component")
    |> form_submit("#add-player", new_player: new_player)
    |> assert_element("#lobby_component")
    |> click("#toggle-ready")
    |> assert_redirect("/dreadnought/play")
  end

  test "Quick Demo", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dreadnought")
    view
    |> click("#link-demo")
    |> assert_redirect("/dreadnought/demo")
    assert has_element?(view, "#unit-1")
  end

  test "Gallery from Homepage", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dreadnought")
    assert view
    |> element("#link-gallery")
    |> render_click() =~ "Gallery"
  end

  # *** *******************************
  # *** ASSERTS - GENERAL HTML

  # TODO move these to a helper module
  defp assert_element(view, selector) do
    assert has_element?(view, selector)
    view
  end

  defp form_submit(view, selector, form_data) do
    view
    |> form(selector, form_data)
    |> render_submit
    view
  end

  #defp refute_element(view, selector, text_filter \\ nil) do
  #  refute has_element?(view, selector, text_filter)
  #  view
  #end

end
