defmodule TenanteeWeb.CommunicationViewTest do
  use TenanteeWeb.ConnCase, async: true
  import Phoenix.View

  @communication %{
    id: 1,
    type: "email",
    value: "test@test.test"
  }

  test "renders show.json" do
    assert render(TenanteeWeb.CommunicationView, "show.json", %{communications: [@communication]}) ==
             %{communications: [@communication]}
  end
end
