defmodule TenanteeWeb.ExpenseView do
  use TenanteeWeb, :view
  alias TenanteeWeb.PropertyView
  alias Tenantee.Repo

  def render("show.json", %{expense: expense}) do
    property_map =
      if Ecto.assoc_loaded?(expense.property) do
        %{
          property:
            PropertyView.render("show_without_tenants.json", %{
              property: Repo.preload(expense.property, :tenants)
            })
        }
      else
        %{}
      end

    %{
      id: expense.id,
      amount: expense.amount,
      description: expense.description,
      date: expense.inserted_at
    }
    |> Map.merge(property_map)
  end

  def render("show.json", %{expenses: expenses}) do
    %{
      expenses: Enum.map(expenses, &render("show.json", %{expense: &1}))
    }
  end
end
