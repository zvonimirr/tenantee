defmodule TenanteeWeb.HomeLiveTest do
  use TenanteeWeb.ConnCase
  import Tenantee.Test.Utils
  import Tenantee.Test.Factory.{Property, Tenant}
  import Phoenix.LiveViewTest
  import Mock
  alias Tenantee.Entity.Tenant
  alias Tenantee.Jobs.Rent
  @endpoint TenanteeWeb.Endpoint

  test "renders modal when config is missing", %{conn: conn} do
    with_mock Tenantee.Config,
      get: fn _key, _b -> nil end,
      lacks_config?: fn -> true end do
      {:ok, _view, html} = live(conn, "/")

      assert decode_html_entities(html) =~ "Looks like you haven't set up your instance yet"
    end
  end

  test "renders when config is not missing", %{conn: conn} do
    name = Faker.Person.first_name()

    with_mock Tenantee.Config,
      get: fn _key, _b -> name end,
      lacks_config?: fn -> false end do
      {:ok, _view, html} = live(conn, "/")

      assert decode_html_entities(html) =~ "Hey there, #{name}"
    end
  end

  test "renders when you have properties and tenants", %{conn: conn} do
    {:ok, _property} = generate_property()

    with_mock Tenantee.Config,
      get: fn _key, _b -> "name" end,
      lacks_config?: fn -> false end do
      {:ok, _view, html} = live(conn, "/")

      assert decode_html_entities(html) =~ "Looks like you own 1 property"
    end
  end

  test "renders when you have unpaid rents", %{conn: conn} do
    {:ok, property} = generate_property()
    {:ok, tenant} = generate_tenant()
    Tenant.add_to_property(tenant.id, property.id)
    Rent.generate_rents()

    with_mock Tenantee.Config,
      get: fn _key, _b -> "name" end,
      lacks_config?: fn -> false end do
      {:ok, _view, html} = live(conn, "/")

      assert decode_html_entities(html) =~ "You have 1 unpaid and 0 overdue rents"
    end
  end
end
