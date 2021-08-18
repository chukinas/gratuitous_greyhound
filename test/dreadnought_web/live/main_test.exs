defmodule DreadnoughtWeb.MainLiveTest do

  use DreadnoughtWeb.ConnCase
  import DreadnoughtWeb.TestHelpers
  import Phoenix.LiveViewTest

  # *** *******************************
  # *** TESTS

  test "Redirect / to /dreadnought", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~ "/dreadnought"
  end

  # TODO test for presence of play component
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

end
