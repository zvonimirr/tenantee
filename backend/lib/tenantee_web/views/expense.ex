defmodule TenanteeWeb.ExpenseView do
  use TenanteeWeb, :view
  alias TenanteeWeb.PropertyView

  def render("show.json", %{expense: expense}) do
    %{
      id: expense.id,
      amount: expense.amount,
      description: expense.description,
      date: expense.inserted_at,
      property: render(PropertyView, "show.json", property: expense.property)
    }
  end

  def render("show.json", %{expenses: expenses}) do
    %{
      expenses: Enum.map(expenses, &render("show.json", %{expense: &1}))
    }
  end
end
