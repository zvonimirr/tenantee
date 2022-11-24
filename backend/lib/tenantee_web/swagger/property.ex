defmodule TenanteeWeb.Swagger.Property do
  @moduledoc """
  Swagger schema for Property
  """
  use PhoenixSwagger

  defmacro __using__(_opts) do
    quote do
      use PhoenixSwagger

      swagger_path :add do
        post("/properties")
        summary("Add a new property")

        parameters do
          property(:body, Schema.ref(:PropertyRequest), "Property to add", required: true)
        end

        response(201, "Property added", Schema.ref(:PropertyResponse))
        response(400, "Invalid params")
      end

      swagger_path :find do
        get("/api/properties/{id}")
        summary("Find a property by ID")

        parameters do
          property(:path, :string, "ID of property to fetch", required: true)
        end

        response(200, "Property found", Schema.ref(:PropertyResponse))
        response(404, "Property not found")
      end

      swagger_path :list do
        get("/api/properties")
        summary("List all properties")

        response(200, "Properties found", Schema.ref(:PropertyResponseList))
      end

      swagger_path :update do
        patch("/api/properties/{id}")
        summary("Update a property")

        parameters do
          id(:path, :string, "ID of property to update", required: true)
          property(:body, Schema.ref(:PropertyRequest), "Property to update", required: true)
        end

        response(200, "Property updated", Schema.ref(:PropertyResponse))
        response(404, "Property not found")
      end

      swagger_path :delete_by_id do
        delete("/api/properties/{id}")
        summary("Delete a property")

        parameters do
          id(:path, :string, "ID of property to delete", required: true)
        end

        response(200, "Property deleted")
        response(404, "Property not found")
      end

      swagger_path :add_tenant do
        put("/api/properties/{id}/tenants/{tenant}")
        summary("Add a tenant to a property")

        parameters do
          id(:path, :string, "ID of property to add tenant to", required: true)
          tenant(:path, :string, "ID of tenant to add", required: true)
        end

        response(200, "Tenant added to property", Schema.ref(:PropertyResponse))
        response(404, "Property or tenant not found")
      end

      swagger_path :remove_tenant do
        delete("/api/properties/{id}/tenants/{tenant}")
        summary("Remove a tenant from a property")

        parameters do
          id(:path, :string, "ID of property to remove tenant from", required: true)
          tenant(:path, :string, "ID of tenant to remove", required: true)
        end

        response(200, "Tenant removed from property", Schema.ref(:PropertyResponse))
        response(404, "Property or tenant not found")
      end

      swagger_path :unpaid_rents do
        get("/api/properties/{id}/rents/unpaid")
        summary("List unpaid rents for a property")

        parameters do
          id(:path, :string, "ID of property to list unpaid rents for", required: true)
        end

        response(200, "Unpaid rents", Schema.ref(:UnpaidPropertyRentResponse))
      end

      def swagger_definitions do
        %{
          Price:
            swagger_schema do
              title("Price")
              description("Price of a property")

              properties do
                amount(:integer, "Amount", required: true)
                currency(:string, "Currency", required: true)
              end
            end,
          PropertyDto:
            swagger_schema do
              title("Property DTO")
              description("Property DTO used for creating and updating properties")

              properties do
                id(:integer, "ID of the property", required: true)
                name(:string, "Name of the property", required: true)
                description(:string, "Description of the property")
                location(:string, "Location of the property", required: true)
                price(:integer, "Price of the property", required: true)
                currency(:string, "Currency of the property price", required: true)

                due_date_modifier(
                  :integer,
                  "Due date modifier (in seconds). The due date of a rent is calculated by adding this value to the rent's start date (1st of the month)"
                )
              end
            end,
          PropertyRequest:
            swagger_schema do
              title("Property request")
              description("Property Request used for creating and updating properties")

              properties do
                property(Schema.ref(:PropertyDto), "Property", required: true)
              end
            end,
          PropertyResponseObject:
            swagger_schema do
              title("Property response object")
              description("Property response object")

              properties do
                id(:integer, "ID of the property", required: true)
                name(:string, "Name of the property", required: true)
                description(:string, "Description of the property")
                location(:string, "Location of the property", required: true)
                price(Schema.ref(:Price), "Price of the property", required: true)

                tenants(:array, "Tenants of the property",
                  items: Schema.ref(:TenantResponseObject)
                )
              end
            end,
          PropertyResponse:
            swagger_schema do
              title("Property response")
              description("Property response")

              properties do
                property(Schema.ref(:PropertyResponseObject), "Property", required: true)
              end
            end,
          PropertyResponseList:
            swagger_schema do
              title("Property response list")
              description("Property response list")

              properties do
                properties(:array, "Properties", items: Schema.ref(:PropertyResponseObject))
              end
            end,
          UnpaidPropertyRent:
            swagger_schema do
              title("Unpaid property rent")
              description("Unpaid property rent")

              properties do
                due_date(:string, "Due date of the rent", required: true)
                tenant(Schema.ref(:TenantResponseObject), "Tenant", required: true)
              end
            end,
          UnpaidPropertyRentResponse:
            swagger_schema do
              title("Unpaid property rent response")
              description("Unpaid property rent response")

              properties do
                rents(:array, "Unpaid rents", items: Schema.ref(:UnpaidPropertyRent))
              end
            end
        }
      end
    end
  end
end
