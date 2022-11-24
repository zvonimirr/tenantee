defmodule TenanteeWeb.RentView do
  use TenanteeWeb, :view

  def render("show.json", %{rent: rent}) do
    tenant =
      if Map.has_key?(rent, :tenant) and Ecto.assoc_loaded?(rent.tenant) do
        %{
          tenant: %{
            id: rent.tenant.id,
            name: rent.tenant.first_name <> " " <> rent.tenant.last_name
          }
        }
      else
        %{}
      end

    property =
      if Map.has_key?(rent, :property) and Ecto.assoc_loaded?(rent.property) do
        %{
          property: %{
            id: rent.property.id,
            name: rent.property.name
          }
        }
      else
        %{}
      end

    %{
      id: rent.id,
      due_date: rent.due_date,
      paid: rent.paid
    }
    |> Map.merge(tenant)
    |> Map.merge(property)
  end

  def render("show.json", %{rents: rents}) do
    %{
      rents: Enum.map(rents, &render("show.json", %{rent: &1}))
    }
  end
end
