defmodule TenanteeWeb.RentView do
  alias Tenantee.Rent.Schema
  alias Tenantee.Tenant
  alias Tenantee.Property
  alias TenanteeWeb.PropertyView
  alias TenanteeWeb.TenantView
  use TenanteeWeb, :view

  def render(
        "show.json",
        %{
          rent:
            %Schema{
              tenant: %Tenant.Schema{},
              property: %Property.Schema{}
            } = rent
        }
      ) do
    render("show.json", %{rent: Map.drop(rent, [:tenant, :property])})
    |> Map.put(
      :tenant,
      render(TenantView, "show.json", %{tenant: Tenant.load_finances(rent.tenant)})
    )
    |> Map.put(
      :property,
      render(PropertyView, "show.json", %{property: Property.load_revenue(rent.property)})
    )
  end

  def render("show.json", %{rent: rent}) do
    %{
      id: rent.id,
      due_date: rent.due_date,
      paid: rent.paid
    }
  end

  def render("show.json", %{rents: rents}) do
    %{
      rents: Enum.map(rents, &render("show.json", %{rent: &1}))
    }
  end
end
