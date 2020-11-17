defmodule ChukinasWeb.PageControllerTest do
  use ChukinasWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Jonathan Chukinas"
  end
end
