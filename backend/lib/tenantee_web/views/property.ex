defmodule TenanteeWeb.PropertyView do
  use TenanteeWeb, :view
  alias Tenantee.Tenant
  alias TenanteeWeb.TenantView
  alias TenanteeWeb.ExpenseView

  def render("show.json", %{properties: properties}) do
    %{
      properties: Enum.map(properties, &render("show.json", %{property: &1}))
    }
  end

  def render("show.json", %{property: property})
      when is_list(property.tenants) and is_list(property.expenses) do
    render("show.json", %{property: Map.drop(property, [:tenants, :expenses])})
    |> Map.put_new(
      :tenants,
      render(TenantView, "show.json", %{
        tenants: Enum.map(property.tenants, &Tenant.load_finances/1)
      })
      |> Map.get(:tenants)
    )
    |> Map.put_new(
      :expenses,
      Enum.map(property.expenses, &render(ExpenseView, "show.json", %{expense: &1}))
    )
  end

  def render("show.json", %{property: property}) do
    %{
      id: property.id,
      name: property.name,
      description: property.description,
      location: property.location,
      price: property.price,
      monthly_revenue: property.monthly_revenue,
      tax_percentage: property.tax_percentage,
      due_date_modifier: property.due_date_modifier,
      inserted_at: property.inserted_at,
      updated_at: property.updated_at
    }
  end

  def render("show_rent.json", %{rent: rent}) do
    %{
      rent: %{
        tenant: render(TenantView, "show.json", %{tenant: Tenant.load_finances(rent.tenant)}),
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
      message: "Property deleted"
    }
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end
