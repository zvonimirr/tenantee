defmodule TenanteeWeb.Swagger.Rent do
  @moduledoc """
  Swagger schema for Rent
  """
  use PhoenixSwagger

  defmacro __using__(_opts) do
    quote do
      use PhoenixSwagger

      swagger_path :list do
        get("/api/rent")
        summary("List all rents")

        response(200, "List of rents", Schema.ref(:RentList))
      end

      swagger_path :list_paid do
        get("/api/rent/paid")
        summary("List all paid rents")

        response(200, "List of paid rents", Schema.ref(:RentList))
      end

      swagger_path :list_unpaid do
        get("/api/rent/unpaid")
        summary("List all unpaid rents")

        response(200, "List of unpaid rents", Schema.ref(:RentList))
      end

      swagger_path :mark_as_paid do
        post("/api/rent/{id}/mark-as-paid")
        summary("Mark rent as paid")

        parameters do
          id(:path, :integer, "Rent ID", required: true)
        end

        response(200, "Rent marked as paid", Schema.ref(:Rent))
      end

      swagger_path :mark_as_unpaid do
        post("/api/rent/{id}/mark-as-unpaid")
        summary("Mark rent as unpaid")

        parameters do
          id(:path, :integer, "Rent ID", required: true)
        end

        response(200, "Rent marked as unpaid", Schema.ref(:Rent))
      end

      def swagger_definitions do
        %{
          RentTenant:
            swagger_schema do
              title("Rent tenant")
              description("Rent tenant")

              properties do
                id(:integer, "ID", required: true)
                name(:string, "Name", required: true)
              end
            end,
          RentProperty:
            swagger_schema do
              title("Rent property")
              description("Rent property")

              properties do
                id(:integer, "ID", required: true)
                name(:string, "Name", required: true)
              end
            end,
          Rent:
            swagger_schema do
              title("Rent")
              description("Rent")

              properties do
                id(:integer, "ID", required: true)
                due_date(:string, "Due Date", required: true)
                paid(:boolean, "Paid", required: true)
                tenant(Schema.ref(:RentTenant), "Tenant")
                property(Schema.ref(:RentProperty), "Property")
              end
            end,
          RentList:
            swagger_schema do
              title("Rent list")
              description("Rent list")

              properties do
                rents(Schema.ref(:Rent), "Items")
              end
            end
        }
      end
    end
  end
end
