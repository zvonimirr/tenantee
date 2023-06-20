defmodule TenanteeWeb.ErrorHTMLTest do
  alias TenanteeWeb.ErrorHTML
  use TenanteeWeb.ConnCase

  test "renders 404", %{conn: conn} do
    assert get(conn, "/404")
           |> html_response(404) =~ "Uh, oh"
  end

  test "renders unknown template", %{conn: conn} do
    assert ErrorHTML.render("501.html", assigns: [conn: conn]) =~ "Not Implemented"
  end
end
