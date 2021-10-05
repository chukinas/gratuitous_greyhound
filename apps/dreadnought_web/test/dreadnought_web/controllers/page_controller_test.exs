defmodule DreadnoughtWeb.PageControllerTest do
  use DreadnoughtWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn) =~ "/dreadnought"
    #assert html_response(conn, 200) =~ "Jonathan Dreadnought"
  end
end
