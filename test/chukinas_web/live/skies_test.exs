defmodule ChukinasWeb.PageLiveTest do
  use ChukinasWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, skies_live, disconnected_html} = live(conn, "/skies")
    assert disconnected_html =~ "Skies"
    assert render(skies_live) =~ "Skies"
  end

  # TODO tag with something like 'intermediary'?
  test "Next Turn", %{conn: conn} do
    {:ok, view, html} = live(conn, "/skies")
    assert html =~ "Move"
    assert view |> element("#current_phase") |> has_element?()
  end

  # test "Select pilots 1 and 3", %{conn: conn} do
  #   {:ok, skies, _} = live(conn, "/skies")
  #   assert render(skies) =~ "Skies"
  # end
end
