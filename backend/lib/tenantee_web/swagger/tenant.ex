defmodule TenanteeWeb.Swagger.Tenant do
  use PhoenixSwagger

  defmacro __using__(_opts) do
    quote do
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

      swagger_path :find do
        get("/api/tenants/{id}")
        summary("Find a tenant by ID")

        parameters do
          id(:path, :integer, "ID of tenant to fetch", required: true)
        end

        response(200, "Tenant found", Schema.ref(:TenantResponse))
        response(404, "Tenant not found")
      end

      swagger_path :list do
        get("/api/tenants")
        summary("List all tenants")

        response(200, "Tenants found", Schema.ref(:TenantResponseList))
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

      swagger_path :delete_by_id do
        delete("/api/tenants/{id}")
        summary("Delete a tenant by ID")

        parameters do
          id(:path, :integer, "ID of tenant to delete", required: true)
        end

        response(200, "Tenant deleted")
        response(404, "Tenant not found")
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
              title("Tenant request")
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
  end
end
