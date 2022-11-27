defmodule TenanteeWeb.TenantController do
  use TenanteeWeb, :controller
  use TenanteeWeb.Swagger.Tenant
  alias Tenantee.Tenant
  alias Tenantee.Rent
  import Tenantee.Utils.Error, only: [respond: 3]

  def add(conn, %{"tenant" => params}) do
    with {:ok, tenant} <- Tenant.create_tenant(params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{tenant: tenant})
    end
  end

  def add(conn, _params) do
    respond(conn, :unprocessable_entity, "Invalid tenant")
  end

  def find(conn, %{"id" => id}) do
    with {:ok, tenant} <- Tenant.get_tenant_by_id(id) do
      conn
      |> render("show.json", %{tenant: tenant})
    else
      {:error, :not_found} -> respond(conn, :not_found, "Tenant not found")
    end
  end

  def list(conn, _params) do
    with tenants <- Tenant.get_all_tenants() do
      render(conn, "show.json", %{tenants: tenants})
    end
  end

  def update(conn, %{
        "id" => id,
        "tenant" => params
      }) do
    with {:ok, tenant} <- Tenant.update_tenant(id, params) do
      conn
      |> render("show.json", %{tenant: tenant})
    else
      {:error, :not_found} -> respond(conn, :not_found, "Tenant not found")
    end
  end

  def update(conn, _params) do
    respond(conn, :unprocessable_entity, "Invalid tenant")
  end

  def delete_by_id(conn, %{"id" => id}) do
    case Tenant.delete_tenant(id) do
      {:ok, :deleted} -> respond(conn, :no_content, "Tenant deleted")
      {:error, :not_found} -> respond(conn, :not_found, "Tenant not found")
    end
  end

  def all_rents(conn, %{"id" => id}) do
    with {:ok, _tenant} <- Tenant.get_tenant_by_id(id),
         rents <- Rent.get_all_rents_by_tenant_id(id) do
      render(conn, "show_rent.json", %{rents: rents})
    else
      {:error, :not_found} -> respond(conn, :not_found, "Tenant not found")
    end
  end

  def unpaid_rents(conn, %{"id" => id}) do
    with {:ok, _tenant} <- Tenant.get_tenant_by_id(id),
         rents <- Rent.get_unpaid_rents_by_tenant_id(id) do
      render(conn, "show_rent.json", %{rents: rents})
    else
      {:error, :not_found} -> respond(conn, :not_found, "Tenant not found")
    end
  end
end
