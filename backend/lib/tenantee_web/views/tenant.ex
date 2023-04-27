defmodule TenanteeWeb.TenantView do
  use TenanteeWeb, :view
  alias TenanteeWeb.RentView
  alias TenanteeWeb.CommunicationView
  alias Tenantee.Rent

  def render("show.json", %{tenants: tenants}) do
    %{
      tenants: Enum.map(tenants, &render("show.json", %{tenant: &1}))
    }
  end

  def render("show.json", %{tenant: tenant})
      when is_list(tenant.properties) and is_list(tenant.communications) do
    render("show.json", %{tenant: Map.drop(tenant, [:properties])})
    |> Map.replace(:properties, Enum.map(tenant.properties, &Map.drop(&1, [:tenants, :expenses])))
    |> Map.replace(
      :communications,
      render(CommunicationView, "show.json", %{communications: tenant.communications})
      |> Map.get(:communications)
    )
    |> Map.replace(
      :unpaid_rents,
      render(RentView, "show.json", %{rents: Rent.get_unpaid_rents_by_tenant_id(tenant.id)})
      |> Map.get(:rents)
    )
  end

  def render("show.json", %{tenant: tenant}) do
    %{
      id: tenant.id,
      name: tenant.first_name <> " " <> tenant.last_name,
      communications: [],
      debt: tenant.debt,
      income: tenant.income,
      unpaid_rents: [],
      properties: []
    }
  end

  def render("show_rent.json", %{rent: rent}) do
    %{
      rent: %{
        id: rent.id,
        property: %{
          id: rent.property.id,
          name: rent.property.name
        },
        paid: rent.paid,
        due_date: rent.due_date
      }
    }
  end

  def render("show_rent.json", %{rents: rents}) do
    %{
      rents:
        Enum.map(rents, fn rent ->
          render("show_rent.json", %{rent: rent}) |> Map.get(:rent)
        end)
    }
  end

  def render("delete.json", %{}) do
    %{
      message: "Tenant deleted"
    }
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end
