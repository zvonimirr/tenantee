defmodule TenanteeWeb.Swagger.Tenant do
  @moduledoc """
  Swagger schema for Tenant
  """
  use PhoenixSwagger

  defmacro __using__(_opts) do
    quote do
      use PhoenixSwagger

      swagger_path :add do
        post("/api/tenants")
        summary("Add a new tenant")

        parameters do
          tenant(:body, Schema.ref(:Tenant), "Tenant to add", required: true)
        end

        response(201, "Tenant created", Schema.ref(:Tenant))
        response(422, "Invalid tenant")
        response(400, "Invalid params")
      end

      swagger_path :find do
        get("/api/tenants/{id}")
        summary("Find a tenant by ID")

        parameters do
          id(:path, :integer, "ID of tenant to fetch", required: true)
        end

        response(200, "Tenant found", Schema.ref(:Tenant))
        response(404, "Tenant not found")
      end

      swagger_path :list do
        get("/api/tenants")
        summary("List all tenants")

        response(200, "Tenants found", Schema.ref(:TenantList))
      end

      swagger_path :update do
        patch("/api/tenants/{id}")
        summary("Update a tenant by ID")

        parameters do
          id(:path, :integer, "ID of tenant to update", required: true)
          tenant(:body, Schema.ref(:Tenant), "Tenant to update", required: true)
        end

        response(200, "Tenant updated", Schema.ref(:Tenant))
        response(422, "Invalid tenant")
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

      swagger_path :all_rents do
        get("/api/tenants/{id}/rents")
        summary("List all rents for a tenant")

        parameters do
          id(:path, :integer, "ID of tenant to fetch rents for", required: true)
        end

        response(200, "Rents found", Schema.ref(:RentList))
        response(404, "Tenant not found")
      end

      swagger_path :unpaid_rents do
        get("/api/tenants/{id}/rents/unpaid")
        summary("List unpaid rents for tenants")

        parameters do
          id(:path, :integer, "ID of tenant to list unpaid rents for", required: true)
        end

        response(200, "Unpaid rents", Schema.ref(:RentList))
        response(404, "Tenant not found")
      end

      def swagger_definitions do
        %{
          Communication:
            swagger_schema do
              title("Communication channel")
              description("A communication channel")

              properties do
                id(:integer, "ID of communication channel", required: true)
                type(:string, "Type of communication channel", required: true)
                value(:string, "Value of communication channel", required: true)
              end
            end,
          Tenant:
            swagger_schema do
              title("Tenant")
              description("A tenant")

              properties do
                id(:integer, "ID of tenant", required: true)
                name(:string, "Name of tenant (only in response)", required: true)
                first_name(:string, "Tenant first name", required: true)
                last_name(:string, "Tenant last name", required: true)
                debt(Schema.ref(:Price), "Debt of tenant (only in response)")
                income(Schema.ref(:Price), "Predicted income for this tenant (only in response)")

                communications(:array, "Communication channels of tenant",
                  items: Schema.ref(:Communication)
                )

                unpaid_rents(:array, "Unpaid rents (only in response)",
                  items: Schema.ref(:Rent),
                  required: false
                )

                properties(:array, "Properties of a tenant (only in response)",
                  items: Schema.ref(:Property),
                  required: false
                )
              end
            end,
          TenantList:
            swagger_schema do
              title("Tenant list")
              description("List of tenants")

              properties do
                tenants(
                  Schema.array(:Tenant),
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
