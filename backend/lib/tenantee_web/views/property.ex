defmodule TenanteeWeb.PropertyView do
  use TenanteeWeb, :view
  alias TenanteeWeb.TenantView

  def render("show.json", %{properties: properties}) do
    %{
      properties: Enum.map(properties, &render("show.json", %{property: &1}))
    }
  end

  def render("show.json", %{property: property}) do
    price = Tenantee.Utils.Currency.convert(property.price) |> Money.round(currency_digits: 2)
    monthly_revenue = Tenantee.Stats.get_monthly_revenue(property)

    %{
      id: property.id,
      name: property.name,
      description: property.description,
      location: property.location,
      price: price,
      monthly_revenue: monthly_revenue,
      due_date_modifier: property.due_date_modifier,
      inserted_at: property.inserted_at,
      updated_at: property.updated_at,
      tenants: render(TenantView, "show.json", %{tenants: property.tenants}) |> Map.get(:tenants)
    }
  end

  def render("show_rent.json", %{rent: rent}) do
    %{
      rent: %{
        tenant: render(TenantView, "show.json", %{tenant: rent.tenant}),
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
