defmodule TenanteeWeb.RentView do
  use TenanteeWeb, :view

  def render("show.json", %{rent: rent}) do
    %{
      id: rent.id,
      due_date: rent.due_date,
      paid: rent.paid
    }
  end
end
