defmodule TenanteeWeb.RentController do
  use TenanteeWeb, :controller
  use TenanteeWeb.Swagger.Rent
  alias Tenantee.Rent
  import Tenantee.Utils.Error, only: [respond: 3]

  def list(conn, _) do
    with rents <- Rent.get_all_rents() do
      render(conn, "show.json", %{rents: rents})
    end
  end

  def list_paid(conn, _) do
    with rents <- Rent.get_rents_by_paid(true) do
      render(conn, "show.json", %{rents: rents})
    end
  end

  def list_unpaid(conn, _) do
    with rents <- Rent.get_rents_by_paid() do
      render(conn, "show.json", %{rents: rents})
    end
  end

  def mark_as_paid(conn, %{"id" => id}) do
    case Rent.mark_rent(id, true) do
      {:ok, rent} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{rent: rent})

      {:error, :not_found} ->
        respond(conn, :not_found, "Rent not found")
    end
  end

  def mark_as_unpaid(conn, %{"id" => id}) do
    case Rent.mark_rent(id) do
      {:ok, rent} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{rent: rent})

      {:error, :not_found} ->
        respond(conn, :not_found, "Rent not found")
    end
  end
end
