defmodule TenanteeWeb.TenantController do
  use TenanteeWeb, :controller
  alias Tenantee.Tenant
  use PhoenixSwagger

  swagger_path :add do
    post("/api/tenants")
    summary("Add a new tenant")

    parameters do
      tenant(:body, Schema.ref(:TenantRequest), "Tenant to add", required: true)
    end

    response(201, "Tenant created", Schema.ref(:TenantResponse))
    response(400, "Invalid params")
  end

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

  swagger_path :find do
    get("/api/tenants/{id}")
    summary("Find a tenant by ID")

    parameters do
      id(:path, :integer, "ID of tenant to fetch", required: true)
    end

    response(200, "Tenant found", Schema.ref(:TenantResponse))
    response(404, "Tenant not found")
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

  swagger_path :list do
    get("/api/tenants")
    summary("List all tenants")

    response(200, "Tenants found", Schema.ref(:TenantResponseList))
  end

  def list(conn, _params) do
    with tenants <- Tenant.get_all_tenants() do
      render(conn, "show.json", %{tenants: tenants})
    end
  end

  swagger_path :update do
    patch("/api/tenants/{id}")
    summary("Update a tenant by ID")

    parameters do
      id(:path, :integer, "ID of tenant to update", required: true)
      tenant(:body, Schema.ref(:TenantRequest), "Tenant to update", required: true)
    end

    response(200, "Tenant updated", Schema.ref(:TenantResponse))
    response(404, "Tenant not found")
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

  swagger_path :delete_by_id do
    delete("/api/tenants/{id}")
    summary("Delete a tenant by ID")

    parameters do
      id(:path, :integer, "ID of tenant to delete", required: true)
    end

    response(200, "Tenant deleted")
    response(404, "Tenant not found")
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

  def swagger_definitions do
    %{
      TenantDto:
        swagger_schema do
          title("Tenant DTO")
          description("Tenant DTO used for creating and updating tenants")

          properties do
            first_name(:string, "Tenant first name", required: true)
            last_name(:string, "Tenant last name", required: true)
            phone(:string, "Tenant phone number")
            email(:string, "Tenant email address")
          end
        end,
      TenantRequest:
        swagger_schema do
          title("Tenant Request")
          description("Tenant request used for creating and updating tenants")

          properties do
            tenant(Schema.ref(:TenantDto), "Tenant to create or update", required: true)
          end
        end,
      TenantResponseObject:
        swagger_schema do
          title("Tenant response object")
          description("Tenant response object")

          properties do
            id(:integer, "ID of tenant", required: true)
            name(:string, "Name of tenant", required: true)
            phone(:string, "Phone number of tenant")
            email(:string, "Email of tenant")
            description(:string, "Description of tenant", required: true)
          end
        end,
      TenantResponse:
        swagger_schema do
          title("Tenant response")
          description("Tenant response")

          properties do
            tenant(Schema.ref(:TenantResponseObject), "Tenant", required: true)
          end
        end,
      TenantResponseList:
        swagger_schema do
          title("Tenant response list")
          description("Tenant response list")

          properties do
            tenants(
              Schema.array(:TenantResponseObject),
              "Tenants",
              required: true
            )
          end
        end
    }
  end
end
