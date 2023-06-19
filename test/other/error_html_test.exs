defmodule TenanteeWeb.ErrorHTMLTest do
  use TenanteeWeb.ConnCase

  test "renders 404", %{conn: conn} do
    assert get(conn, "/404")
           |> html_response(404) =~ "Uh, oh"
  end
end
