defmodule TenanteeWeb.ExpenseView do
  use TenanteeWeb, :view

  def render("show.json", %{expense: expense}) do
    %{
      id: expense.id,
      amount: expense.amount,
      description: expense.description,
      date: expense.inserted_at
    }
  end
end
