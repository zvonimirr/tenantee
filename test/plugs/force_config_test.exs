defmodule TenanteeWeb.Plugs.ForceConfigTest do
  use TenanteeWeb.ConnCase
  import Mock
  @endpoint TenanteeWeb.Endpoint

  test "redirects to homepage if config is not set", %{conn: conn} do
    with_mock Tenantee.Config,
      lacks_config?: fn -> true end do
      assert redirected_to(get(conn, "/tenants")) == "/"
      assert redirected_to(get(conn, "/tenants/new")) == "/"
      assert redirected_to(get(conn, "/tenants/1")) == "/"

      assert redirected_to(get(conn, "/properties")) == "/"
      assert redirected_to(get(conn, "/properties/new")) == "/"
      assert redirected_to(get(conn, "/properties/1")) == "/"
    end
  end
end
