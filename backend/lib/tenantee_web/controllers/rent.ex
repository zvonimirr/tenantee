defmodule TenanteeWeb.RentController do
  use TenanteeWeb, :controller
  alias Tenantee.Rent

  def mark_as_paid(conn, %{"id" => id}) do
    with {:ok, rent} <- Rent.mark_rent(id, true) do
      conn
      |> put_status(:ok)
      |> render("show.json", %{rent: rent})
    end
  end

  def mark_as_unpaid(conn, %{"id" => id}) do
    with {:ok, rent} <- Rent.mark_rent(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", %{rent: rent})
    end
  end
end
