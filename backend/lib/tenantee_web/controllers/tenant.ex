defmodule TenanteeWeb.TenantController do
  use TenanteeWeb, :controller
  use TenanteeWeb.Swagger.Tenant

  alias Tenantee.Tenant

  def add(conn, %{"tenant" => params}) do
    with {:ok, tenant} <- Tenant.create_tenant(params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{tenant: tenant})
    end
  end

  def add(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", %{message: "Invalid params"})
  end

  def find(conn, %{"id" => id}) do
    with tenant <- Tenant.get_tenant_by_id(id) do
      if tenant do
        render(conn, "show.json", %{tenant: tenant})
      else
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: "Tenant not found"})
      end
    end
  end

  def find(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", %{message: "Invalid params"})
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
      render(conn, "show.json", %{tenant: tenant})
    end
  end

  def update(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", %{message: "Invalid params"})
  end

  def delete_by_id(conn, %{"id" => id}) do
    with {affected_rows, nil} <- Tenant.delete_tenant(id) do
      if affected_rows < 1 do
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: "Tenant not found"})
      else
        render(conn, "delete.json", %{})
      end
    end
  end

  def delete_by_id(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", %{message: "Invalid params"})
  end
end
