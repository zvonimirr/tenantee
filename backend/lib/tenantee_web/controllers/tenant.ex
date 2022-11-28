defmodule TenanteeWeb.TenantController do
  use TenanteeWeb, :controller
  use TenanteeWeb.Swagger.Tenant
  alias Tenantee.Tenant
  alias Tenantee.Rent
  import Tenantee.Utils.Error, only: [respond: 3]

  def add(
        conn,
        %{
          "first_name" => _first_name,
          "last_name" => _last_name
        } = params
      ) do
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
    case Tenant.get_tenant_by_id(id, true) do
      {:ok, tenant} ->
        conn
        |> render("show.json", %{tenant: tenant})

      {:error, :not_found} ->
        respond(conn, :not_found, "Tenant not found")
    end
  end

  def list(conn, _params) do
    with tenants <- Tenant.get_all_tenants() do
      render(conn, "show.json", %{tenants: tenants})
    end
  end

  def update(
        conn,
        %{
          "id" => id
        } = params
      ) do
    case Tenant.update_tenant(id, params |> Map.delete("id")) do
      {:ok, tenant} ->
        conn
        |> render("show.json", %{tenant: tenant})

      {:error, :not_found} ->
        respond(conn, :not_found, "Tenant not found")
    end
  end

  def delete_by_id(conn, %{"id" => id}) do
    case Tenant.delete_tenant(id) do
      {:ok, :deleted} -> respond(conn, :ok, "Tenant deleted")
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
