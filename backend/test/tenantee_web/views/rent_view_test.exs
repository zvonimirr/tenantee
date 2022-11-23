defmodule TenanteeWeb.RentViewTest do
  use TenanteeWeb.ConnCase, async: true

  import Phoenix.View

  @rent %{
    id: 1,
    due_date: ~D[2019-01-01],
    paid: false,
    tenant_id: 1,
    property_id: 1
  }

  @rent_rendered %{
    id: 1,
    due_date: ~D[2019-01-01],
    paid: false
  }

  test "renders show.json" do
    assert render(TenanteeWeb.RentView, "show.json", rent: @rent) == @rent_rendered
  end
end
