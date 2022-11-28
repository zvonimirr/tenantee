defmodule TenanteeWeb.TenantView do
  use TenanteeWeb, :view
  alias TenanteeWeb.RentView
  alias Tenantee.Rent
  alias Tenantee.Stats

  def render("show.json", %{tenants: tenants}) do
    %{
      tenants: Enum.map(tenants, &render("show.json", %{tenant: &1}))
    }
  end

  def render("show.json", %{tenant: tenant}) do
    debt = Stats.get_debt(tenant) |> get_money()
    income = Stats.get_income(tenant) |> get_money()

    %{
      id: tenant.id,
      name: tenant.first_name <> " " <> tenant.last_name,
      phone: tenant.phone,
      email: tenant.email,
      unpaid_rents:
        render(RentView, "show.json", %{
          rents: Rent.get_unpaid_rents_by_tenant_id(tenant.id)
        })
        |> Map.get(:rents)
    }
    |> Map.put(:debt, debt)
    |> Map.put(:income, income)
    |> Map.filter(fn {_k, v} -> not is_nil(v) end)
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

  defp get_money(%Money{} = m) when is_map(m), do: m
  defp get_money(_), do: nil
end
